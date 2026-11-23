CC      ?= gcc
PKG     := $(shell pkg-config --exists webkit2gtk-4.1 && echo webkit2gtk-4.1 || echo webkit2gtk-4.0)
CFLAGS  ?= -O2 -s -Wall -Wno-deprecated-declarations $(shell pkg-config --cflags $(PKG))
LDLIBS  := $(shell pkg-config --libs $(PKG))

pero: pero.c
	$(CC) $(CFLAGS) -o $@ $< $(LDLIBS)

run: pero
	./pero

install: pero
	install -Dm755 pero /usr/local/bin/pero
	install -Dm644 pero.desktop /usr/local/share/applications/pero.desktop
	install -Dm644 icon.svg /usr/local/share/icons/hicolor/scalable/apps/pero.svg
	@echo ""
	@echo "Готово!"
	@echo "  Запуск:  pero"
	@echo "  Меню:   найдите «pero»"

clean:
	rm -f pero

.PHONY: run install clean
