forkpush() {
  if [ -z "$1" ]; then
		echo "please provide the name of the github account to fork with"
		echo "> forkpush [name]"
		return
	fi
  if [ ! -d .git ]; then
    echo "this is not a git repository"
    return
  fi
  remote=$(git config --get remote.origin.url)
  if [[ remote == *"github.com" ]]; then
    reponame=$(echo $remote | cut -d "/" -f 5-)
  else
    reponame=$(basename "$PWD")
  fi
  while true; do
	    read -p "are you sure you want to fork $remote to https://github.com/$1/$reponame [y/n]?  " yn
	    case $yn in
	        [Yy]* ) break;;
	        [Nn]* ) return;;
	        * ) echo "Please answer yes or no.";;
	    esac
	done
  github="github.com"
  if [[ "${remote/github}" = "$remote" ]]; then # not a clone from github; must create repo instead of forking
    echo "creating repo"
    curl -u "$1" "https://api.github.com/$1/repos" -X POST -H "Content-Type: application/json" -d '{"name":"$reponame"}' > /dev/null
  else
    echo "forking repo"
    repo=$(echo $remote | cut -d "/" -f 4-)
    curl -u "$1" "https://api.github.com/repos/$repo/forks" -X POST > /dev/null
  fi
  git remote add myfork git@github.com:$1/$reponame
  sleep 2
  git push --set-upstream myfork $(git branch | grep "*" | cut -c 3-)
}
