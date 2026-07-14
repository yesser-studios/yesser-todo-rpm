SUBDIR := $(shell dirname $(spec))

srpm:
	cp ~/.curlrc ~/.curlrc.bak
	echo "user-agent = \"CoprBuilderCurl/1.0\"" >> ~/.curlrc

	dnf install -y cargo spectool rpm-build git bash tar rpmspec

	../vendor.sh ./*.spec
	mv ./*.tar.* ..

	rpmbuild -bs \
	  --define "_sourcedir $(SUBDIR)" \
	  --define "_srcrpmdir $(outdir)" \
	  ./*.spec

	rm ~/.curlrc
	mv ~/.curlrc.bak ~/.curlrc

