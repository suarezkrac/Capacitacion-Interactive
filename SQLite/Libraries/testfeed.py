#!/usr/bin/python3
# testfeed.py by Bill Weinman <http://bw.org/contact/>
# Copyright (c) 2012 The BearHeart Group, LLC
# created 2012-10-03
# as of 2012-11-13

import sys, os
import random, datetime

VERSION = 'version 2012101301'
newlineString = '\n'
linesFile = 'lines.txt'
numberOfItems = 5

rss_top = '<?xml version="1.0" encoding="UTF-8" ?>'

titleString = "Lorem ipsum dolor sit amet."
contentString = "Lorem ipsum dolor sit amet."

feedTitle = 'Test Feed'
feedDescription = 'random things for testing'
fauxurl = 'http://ios.bw.org/doc/'

# Random strings
class RandString:
    _data = []  # array of strings
    _len = 0
    def __init__(self, fn):
        if self._len < 1:
            self.load(fn)

    def load(self, fn):
        f = open(fn, 'rt')
        for line in f:
            line = line.strip()
            if(len(line)):
                self._data.append(htmlEscape(line))
                self._len += 1
        f.close()

    def line(self):
        if self._len < 1: return '0'
        return self._data[random.randint(0, self._len - 1)]

# XML attributes
class attributes:
    def __init__(self, attrs = []):
        self._attrs = attrs

    def add(self, name, value = ''):
        self._attrs.append( [ name, value ] )

    def str(self):
        if self.len():
            strs = []
            for att in self._attrs:
                strs.append( '{}="{}"'.format( att[0], att[1] ) )
            return ' '.join(strs)
        else: return ''

    def len(self):
        return len(self._attrs)

# XML tags and end-tags
class tag:
    ''' type = 0 - begin tag
        type = 1 - end tag
        type = 2 - standalone tag
    '''
    def __init__(self, name, type = 0, attrs = attributes()):
        self._name = name
        self._left = "</" if ( type == 1 ) else "<"
        self._right = " />" if ( type == 2 ) else ">"
        self._attrs = attrs

    def str(self):
        if self._attrs.len():
            return self._left + self._name + ' ' + self._attrs.str() + self._right
        else:
            return self._left + self._name + self._right

# XML container
class container:
    def __init__(self, name, content = '', attrs = attributes()):
        self._name = name
        self._content = content
        self._attrs = attrs

    def str(self):
        a = ''
        a += tag(self._name, 0, self._attrs).str()
        a += self._content
        a += tag(self._name, 1).str()
        a += newlineString
        return a

# XML standalone
class standalone:
    def __init__(self, name, attrs = attributes()):
        self._name = name
        self._attrs = attrs

    def str(self):
        a = ''
        a += tag(self._name, 2, self._attrs).str()
        return a

class item:
    def __init__(self, title, link, date, description):
        self._title = title
        self._link = link
        self._date = date
        self._description = description
    def str(self):
        title = container('title', self._title).str()
        link = container('link', self._link).str()
        description = container('description', self._description).str()
        date = container('pubDate', self._date).str()
        return container('item', newlineString + title + link + description + date).str()

def htmlEscape(s):
    html_escape_table = {
        "&": "&amp;",
        '"': "&quot;",
        "'": "&apos;",
        ">": "&gt;",
        "<": "&lt;",
    }
    return "".join(html_escape_table.get(c, c) for c in s)

def check_cgi():
    if 'GATEWAY_INTERFACE' in os.environ:
        print("Content-type: application/rss+xml\n\n", end='')

def main():
    check_cgi()

    rTitle = RandString(linesFile)

    print(rss_top)
    print(tag('rss', 0, attributes([ [ 'version', '2.0' ] ])).str())
    print(tag('channel', 0).str())
    print(container('title', feedTitle).str(), end='')
    print(container('link', fauxurl).str(), end='')
    print(container('description', feedDescription).str())

    for i in range( 0, numberOfItems ):  # make a feed of n items
        t = datetime.datetime.utcnow()
        tempItemString = "{}{}{}{}{}{}{}".format(t.year, t.month, t.day, t.hour, t.minute, t.second, t.microsecond)
        print( item( rTitle.line(), fauxurl + tempItemString, str(t), contentString ).str() )

    print(tag('channel', 1).str())
    print(tag('rss', 1).str())

if __name__ == "__main__": main()
