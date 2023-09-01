clean:
	-if [ -e /tmp/js-lifecycle ]; then rm -r /tmp/js-lifecycle/; fi
	-git clean -dfX

install-git-deps:
	yarn add --mode=skip-build \
		"npm-lifecycle-scripts@chmeliik/js-lifecycle-scripts#head=npm" \
		"yarn-lifecycle-scripts@chmeliik/js-lifecycle-scripts#head=yarn" \
		"yarnberry-lifecycle-scripts@chmeliik/js-lifecycle-scripts#head=yarnberry"

install-git-dep-workspaces:
	yarn add --mode=skip-build \
		"npm-lifecycle-scripts@chmeliik/js-lifecycle-scripts#head=npm&workspace=my-workspace" \
		"yarn-lifecycle-scripts@chmeliik/js-lifecycle-scripts#head=yarn&workspace=my-workspace" \
		"yarnberry-lifecycle-scripts@chmeliik/js-lifecycle-scripts#head=yarnberry&workspace=my-workspace"

list-results: /tmp/js-lifecycle/.reordered
	@ls /tmp/js-lifecycle/* -1 \
		| sed -e "s;/tmp/js-lifecycle/[0-9]*-;;" -e "s;\.txt;;"

/tmp/js-lifecycle/.reordered:
	@mv /tmp/js-lifecycle/npm 			/tmp/js-lifecycle/01-npm
	@mv /tmp/js-lifecycle/npm-workspace 		/tmp/js-lifecycle/02-npm-workspace
	@mv /tmp/js-lifecycle/yarn 			/tmp/js-lifecycle/03-yarn
	@mv /tmp/js-lifecycle/yarn-workspace		/tmp/js-lifecycle/04-yarn-workspace
	@mv /tmp/js-lifecycle/yarnberry 		/tmp/js-lifecycle/05-yarnberry
	@mv /tmp/js-lifecycle/yarnberry-workspace	/tmp/js-lifecycle/06-yarnberry-workspace
	@touch /tmp/js-lifecycle/.reordered
