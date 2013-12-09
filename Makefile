.PHONY: install uninstall help

help:
	echo "make install"
	echo "make uninstall"

install:
	mkdir -p /etc/gp/images/
	mkdir -p /etc/gp/licenses/
	mkdir -p /etc/gp/uc/
	cp images/* /etc/gp/images/
	cp licenses/* /etc/gp/licenses/
	cp uc/* /etc/gp/uc/
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
	cp gl /bin/
	chmod a+x /bin/gl
	chmod a+r /bin/gl
	apt-get install -y python git gcc g++ trac trac-git tar doxygen valgrind kcachegrind gdb ddd

uninstall:
	rm -rf /etc/gp/
	rm -rf /bin/gp
	rm -rf /bin/ghf
	rm -rf /bin/gsf
	rm -rf /bin/gl
