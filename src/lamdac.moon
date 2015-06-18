--
-- lamdac.moon
--
-- Inspired by Ramda. (ramdajs.com)
--

l = require "lamda"


c = {}

-- ==============================
-- === Collection 
-- ==============================

c.all = l.curry l.all
c.any = l.curry l.any
c.each = l.curry l.each
c.forEach = l.curry l.forEach
c.filter = l.curry l.filter
c.select = l.curry l.select
c.map = l.curry l.map
c.collect = l.curry l.collect

c.reduce = l.curry l.reduce
c.reduceRight = l.curry l.reduceRight
c.reject = l.curry l.reject

c.inject = l.curry l.inject
c.fold = l.curry l.fold
c.foldl = l.curry l.foldl
c.foldr = l.curry l.foldr


c
