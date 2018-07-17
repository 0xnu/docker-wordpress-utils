Docker WordPress Utils
=============

Need a quick way to backup, restore, destroy and upload your Dockerize WordPress stack to AWS S3? These nimble scripts will help you achieve your goal. Tweak **docker-compose.yml** to your specifications.

Prerequisites
-------------

Make the scripts executable:

    chmod +x destroy.sh && chmod +x s3-upload.sh

.env
----

Update **.env** with your MySQL details.

.s3upload.conf
--------------

Update .s3upload.conf with your AWS **access key**, **secret key**, **bucket name**, **AWS region**, and s3 bucket **endpoint URL**. Note: the files are automatically given a timestamp suffix to avoid naming conflicts. For example, `image.png` will be uploaded as `image-1430566517.png`.

Usage
-----

1. Put the scripts somewhere in your root folder (e.g., **/root** if you have an Ubuntu 16.04 installed) and run make. The scripts will work with the assumption you have already setup LAMP/LEMP stack. Don't forget to update your **Container** ID inside the **makefile**!

    ```make
    make up
    ```

2. Backup your Docker WordPress stack.

    ```make
    make backup
    ```

3. Restore your Docker WordPress stack.

    ```make
    make restore
    ```
4. Send your backup to AWS S3.

    ```sh
    sudo ./s3-upload.sh mysql.tar wp-content.tar
    ```
5. Destroy your stack! Tear it down!

    ```sh
    sudo ./destory.sh
    ```

License and Copyright
---------------------

The MIT License (MIT). Copyright (c) 2018 Finbarrs Oketunji.