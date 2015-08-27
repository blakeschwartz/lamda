# Warning 

This code base is currently being assembled. Much of the functionality is untested and much of it is not yet implemented. Check the doc directory for the manual.md. If something is documented then it is probably implemented and tested. 

Also note that there is code that requires Lua 5.2. This may change in the future if 5.1 compatability is deemed necessary. 
---

# lamda
A Lua functional library inspired by Ramda and Underscore. And no, the name is not misspelled. 
It is taken from my favorite JavaScript functional library Ramda, thus (L)ua R(amda).

In the process of building this library it will stay as consistent as possible to the 
interface provided by Ramda and Underscore, taking many of the names from Underscore 
but always using the convention from Ramda of placing the arguments in the best order 
for currying. To understand the motivation for this see the video: 
[Hey Underscore, You're Doing it Wrong!](https://www.youtube.com/watch?v=m3svKOdZijA).

This library is being writter in [Moonscript](http://moonscript.org) as are the code samples and
the test scripts. In the furture, Lua scripts may be developed also.

#Building

Currently there is no build. 

#Testing

Testing is done with [busted](http://olivinelabs.com/busted/). Install it and run it from here.

#Documentation

Documentation will be developed over time. As a feature is completed and tested it will be documented. 
This will be the best indicator in the short term that a feature is ready to use.

#Examples

Coming soon. For now you may look at the test scripts.
