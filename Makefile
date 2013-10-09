.PHONY: install uninstall help

help:
	echo "make install"
	echo "make uninstall"

install:
	mkdir -p /etc/gp/images/
	mkdir -p /etc/gp/licenses/
	cp images/* /etc/gp/images/
	cp licenses/* /etc/gp/licenses/
	chmod -R a+r /etc/gp/
	cp gp /bin/
	chmod a+x /bin/gp
	chmod a+r /bin/gp
	cp gsf /bin/
	chmod a+x /bin/gsf
	chmod a+r /bin/gsf
	cp ghf /bin/
	chmod a+x /bin/ghf
	chmod a+r /bin/ghf
	apt-get install -y python git gcc g++ trac trac-git tar doxygen valgrind kcachegrind gdb ddd

uninstall:
	rm -rf /etc/gp/
	rm -rf /bin/gp
	rm -rf /bin/ghf
	rm -rf /bin/gsf
