


Deploy
------------------------
- setup an access token in dj github - https://betterprogramming.pub/dealing-with-github-password-authentication-deprecation-1b59ced90065 

- put your repos to sync in the resources/json_file

- and run it on server with access to dai gitlab 





Large file stuff
------------------------
- generate test large files with

		$> dd if=/dev/urandom of=resources/dai_to_dj_git_sync.sh/test.largefile.txt bs=150000000 count=1

			or 

		$> head -c 150000000 /dev/urandom > resources/dai_to_dj_git_sync.sh/test.largefile.txt



- git lfs - https://towardsdatascience.com/uploading-large-files-to-github-dbef518fa1a
	- https://git-lfs.github.com/

		Download and install git-lfs by placing it into your $PATH
			or updating your $PATH with: $> export PATH=$PATH:/path/to/git_lfs
				can add this command to ~/.bash_profile, ~/.bashrc, or ~/.profile, etc if you want
			macc os: $> brew install git-lfs

		run the following command once per local repository: 
			$> git lfs install
			you'll see output similar to...
				Updated Git hooks.
				Git LFS initialized.

		select large files in repo with: 
			$> git lfs track 'big_file_pattern i.e. *.largefile.*'
				i.e. $> git lfs track '*.largefile.*'
			This will create a file named .gitattributes, and voilà! You can perform add and commit operations as normal. 

		add .gitattributes to repo:
			$> git add .gitattributes

		Then, you will first need to...
			a) push the files to the LFS: $> git lfs push --all origin master. !! don't think you need to do this. i do normal `git push` and it works fine
			b) push the pointers to GitHub. Here are the commands: $> git push -u origin master
			you'll see output similar to...
				Locking support detected on remote "origin". Consider enabling it with:
  					$ git config lfs.https://gitlab01.daicompanies.com/ibd-analytics/dj_migration/dai_to_dj_sync.git/info/lfs.locksverify true 

		Files on Git LFS are then available on GitHub with the following label next to the file: "stored with git lfs" or "LFS" 

		In order to pull the repository on another device, simply install git-lfs and pull like normal

