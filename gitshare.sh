gitshare () {
	if [ -z "$1" ]; then
		echo "please give a name to the repo!"
		echo "> gitshare [name]"
		return
	fi
	
	while true; do
	    read -p "are you sure you want to share "$(pwd)' [y/n]?  ' yn
	    echo ""
	    case $yn in
	        [Yy]* ) break;;
	        [Nn]* ) return;;
	        * ) echo "Please answer yes or no.";;
	    esac
	done

	if [ ! -e .sharename ]; then
		if [ ! -e ~/.sharerc ]; then
			echo 'no share configured. please add one to ~/.sharerc or .share'
			return
		fi
		share=$(cat ~/.sharerc)
	fi
	share=$(cat .sharename)
	if [[ $(git init) != *"Reinitialized" ]]; then #if it's already a git repo, dont do anything 
		git add -A
		git commit -am "sharing"
	fi
	repo=$share$(id -u -n)'/'$1
	pushd $share > /dev/null
	mkdir -p $(id -u -n)'/'$1'/.git'
	popd > /dev/null
	cp -r .git $repo
	cp -r ./* $repo
	echo 'share this URL for others to clone!'
	echo 'file://'$repo
}
