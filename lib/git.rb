require 'git-ssh-wrapper'
require 'git'
require 'uri'

needs('GITHUB_REPO', 'HEROKU_REPO', 'HEROKU_BRANCH')

module GitPusher extend self
  def deploy(url)
    repo = open_or_setup(
      ENV['GITHUB_REPO']
    )

    wrapped_push(
      repo,
      'heroku',
      ENV['HEROKU_BRANCH']
    )
  end

  def open_or_setup(github_url)
    local_folder = "repos/#{Zlib.crc32(github_url)}"

    repo = begin
      Git.open(local_folder).tap do |g|
        g.fetch
        g.remote('origin').merge
      end
    rescue ArgumentError => e
      `rm -r #{local_folder}` rescue nil
      wrapped_clone(github_url, local_folder)
      retry
    end

    unless repo.remote('heroku').url
      repo.add_remote('heroku', ENV['HEROKU_REPO'])
    end

    repo
  end

  def wrapped_clone(github_url, local_folder)
    wrapper = GitSSHWrapper.new(:private_key_path => '~/.ssh/id_rsa')
    `env #{wrapper.git_ssh} git clone #{github_url} #{local_folder}`
  ensure
    wrapper.unlink
  end

  def wrapped_push(repo, remote = 'heroku', branch = 'master')
    wrapper = GitSSHWrapper.new(:private_key_path => '~/.ssh/id_rsa')
    puts `cd #{repo.dir}; env #{wrapper.git_ssh} git push -f #{remote} #{branch}:master`
  ensure
    wrapper.unlink
  end

  def local_state(github_url)
    repo = open_or_setup(github_url)
    repo.object('HEAD')
  end
end