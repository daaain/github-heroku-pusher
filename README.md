Introduction
============
github-heroku-pusher does pretty much what sounds like it does. It takes a github repo, grabs the latest version and pushes it to heroku.

Setup
=====

In order for the pusher to run, we need to set these six variables:

But first, generate a keypair with `ssh-keygen -t rsa -f ~/path/to/a/tmp-dir/id_rsa 2>&1` (this will be added to your Heroku SSH keys)

*   HEROKU_USERNAME (Example: you@email.com)
*   HEROKU_BRANCH (Example: master)
*   HEROKU_API_KEY (Found at the bottom of the [account page](https://api.heroku.com/account))
*   GITHUB_REPO (Example: git@github.com:ajlai/Test.git)
*   HEROKU_REPO (Example: git@heroku.com:smooth-sword-2980.git)
*   PUBLIC_KEY (contents of the id_rsa.pub file generated above)
*   PRIVATE_KEY (contents of the id_rsa file generated above)

Next, we can set up the app in Heroku:

    git clone git://github.com/maccman/github-heroku-pusher.git
    cd github-heroku-pusher
    heroku create --stack cedar
    git push heroku master

Now, set up the variables from earlier under Heroku's [config vars](http://devcenter.heroku.com/articles/config-vars): `heroku config:set HEROKU_BRANCH=master` and so on

Finally, set up the post-receive url to point to YOUR_APP/post-receive (Example: http://severe-dusk-3039.herokuapp.com/post-receive)

Try pushing a commit to master on your github repo, and watch Heroku redeploy the code!

TODO
====
* Speed up cloning (git clone via http is slow as molasses, let's use git://)
* Support for multiple repo monitoring
* Test cases
