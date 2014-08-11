Simple AWS GPU setup
====================

1. Create your AWS account
--------------------------

If you haven't got an account with Amazon AWS yet, you'll need to create one. Go to http://aws.amazon.com/, click Sign Up and follow the instructions. You'll probably have to receive a phone call from them to confirm your identity.

[Create a new EC2 key pair](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#KeyPairs:) and place your downloaded `.pem` file in your `~/.ssh` directory.

Go to [Security Credentials](https://console.aws.amazon.com/iam/home?#security_credential), click *Access Keys*, and *Create New Access Key*. Copy the secret access key and put it in a temporary file somewhere. You can only see it when you create it, but you can create as many as you want.

Define the following environment variables with the information you obtained in steps 2 and 3 (put these lines in `~/.bash_profile` on OSX or `~/.bashrc` on Linux):

    export AWS_KEYPAIR_NAME=...      # The name of the key pair you created in step 2
    export AWS_SSH_KEY_FILENAME=...  # The path where you put your .pem file in step 2 (e.g. ~/.ssh/foo.pem)
    export AWS_ACCESS_KEY_ID=...     # Found under Security Credentials -> Access Keys
    export AWS_SECRET_ACCESS_KEY=... # The secret key you copied in step 3

Open a new terminal window or reload `.bash_profile`/`.bashrc`

2. Install software
-------------------

[Install pip](http://pip.readthedocs.org/en/latest/installing.html) (a Python package manager) if you don't have it installed already.

Then (on the command line), install [headintheclouds](http://headintheclouds.readthedocs.org):

    pip install headintheclouds

Download this repository:

    git clone git@github.com:andreasjansson/simple-aws-gpu-setup

Cd into the repo root:

    cd simple-aws-gpu-setup

If everything is installed properly, and all your environment variables from step 4 are correct, you should be able to type `fab pricing` and get a table of EC2 spot instance and hourly costs.

3. Create your cheap GPU spot instance
--------------------------------------

Since we'll use a proprietary NVIDIA AWS image, you'll need to agree to some terms and conditions. Go to https://aws.amazon.com/marketplace/pp/B00FYCDDTE, click *Continue*, on the next page click *Subscribe*.

Back on your terminal, type `fab ensemble.up:gpu`. You should get a prompt like this:

    Calculating changes...
    The following servers will be created:
    gpu
    Do you wish to continue? [Y/n]

Answer `Y`

Now a spot instance will be created, based on the configuration in `gpu.yaml`. This will take around five minutes. If for some reason the current spot price is above the bid in `gpu.yaml`, edit that file such that `bid` is higher than the current asking price (or wait for a few hours for the asking price to go down again).

The image defined in `gpu.yaml` (ami-2ca87b44) is based on a stock Ubuntu 14.04 image ([ami-8827efe0](http://thecloudmarket.com/image/ami-8827efe0--ubuntu-images-hvm-ssd-ubuntu-trusty-14-04-amd64-server-20140724)) and is bootstrapped with Theano, NumPy, SciPy, Emacs, and some other goodies. The actual bootstrap script is included in the `bootstrap` directory.

Once that's done you should see your server running if you type

    fab nodes

4. Write some Theano code
-------------------------

Log in to the new server

    fab ssh

On the remote machine, start an IPython notebook on port 80

    sudo ipython notebook --ip=0.0.0.0 --port=80 --no-browser

You can access the notebook using the `public_ip` address from the `fab nodes` command.

Since this notebook is world readable, anyone can access your machine as root. That's a terrible idea. So shut down the notebook by hitting `ctrl-c`.

On your local machine, figure out your public IP address (either just google `what is my ip` or `curl ifconfig.me`). Replace `80: "*"` in the firewall config of `gpu.yaml` with `80: YOUR_PUBLIC_IP`. For the firewall to be applied, once again run

    fab ensemble.up:gpu

Now you can safely start the IPython notebook again.

I added a `check_theano` notebook to the image. Open the IPython notebook web interface in a browser again and click the `check_theano` notebook. Once inside it, click the first cell and hit Run (or `ctrl-return`). It should say "Used the gpu".

**Don't forget to back up your work regularly to S3 or some other persistent storage, since spot instances can be terminated at any point in time**
