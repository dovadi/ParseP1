ParseP1
========

[![Build Status](https://secure.travis-ci.org/dovadi/ParseP1.png?branch=master)](http://travis-ci.org/dovadi/ParseP1)

Basic parser for P1 Companion Standard used by Dutch Smart Meters.

*Library is by no means complete (yet), it is now implemented only on one real example of a so called Dutch smart meter, in this case a Iskra MT382.*

Example of P1 data
==================

<pre>
/ABc1\\1AB123-4567

0-0:96.1.1(1A123456789012345678901234567890)  
1-0:1.8.1(00136.787*kWh)  
1-0:1.8.2(00131.849*kWh)  
1-0:2.8.1(00000.000*kWh)  
1-0:2.8.2(00000.000*kWh)  
0-0:96.14.0(0002)  
1-0:1.7.0(0003.20*kW)  
1-0:2.7.0(0000.00*kW)  
0-0:17.0.0(0999.00*kW)  
0-0:96.3.10(1)  
0-0:96.13.1()  
0-0:96.13.0()  
0-1:24.1.0(3)  
0-1:96.1.0(1234567890123456789012345678901234)  
0-1:24.3.0(120502150000)(00)(60)(1)(0-1:24.2.1)(m3)  
(00092.112)  
0-1:24.4.0(1)  
!
</pre>

Usage
=====

<pre>
p1 = ParseP1::Base.new(p1_string)  
p1.electra_meter_id                                  #-> 1A123456789012345678901234567890
p1.electricity(:type => :import, :tariff => :normal) #-> 116.34 (kWH)
p1.electricity(:type => :import, :actual => :true)   #-> 1245   (watt)
p1.gas_usage                                         #-> 91.224 (m3)
</pre>

See tests for futher available methods


Running tests
=============
First install libraries with:
<pre>
bundle
</pre>

Test with
<pre>
bundle exec rake test 
</pre>
_or_
<pre>
bundle exec guard
</pre>

Caveats
=======

* Library is by no means complete (yet), it is now implemented only on one real example of a so called Dutch smart meter. In this case a Iskra MT382 (see docs and ([manuals](http://www.liander.nl/liander/meters/meterhandleidingen.htm))) delivered by [Liander](http://www.liander.nl/).
* See [ReadP1 Arduino library](https://github.com/dovadi/ReadP1), which is used for posted the P1 data to a Ruby on Rails application.
* Although P1 should be a standard, it is known there are different implementations in the Netherlands alone.
* The library is implemented on the base of one long string received by a Ruby on Rails application. Parsing a text file will fail!

Documentation
=============
 See [Datalogging van "slimme meters"](http://www.zonstraal.be/wiki/Datalogging_van_%22slimme_meters%22) in Dutch

 See [P1 Companion Standard Version 2.2 April 18th 2008 from Enbin](http://read.pudn.com/downloads145/doc/633047/DSMR%20v2.2%20final/Dutch%20Smart%20Meter%20Requirements%20v2.2%20final%20P1.pdf) (also in docs directory)

 See [Representation of P1 telegram P1 Companion Standard Version 4.0 from Netbeheer Nederland](http://www.google.nl/url?sa=t&rct=j&q=p1%20companion%20standard&source=web&cd=1&sqi=2&ved=0CCkQFjAA&url=http%3A%2F%2Fwww.netbeheernederland.nl%2FDecosDocument%2FDownload%2F%3FfileName%3D1uII4GRHFdk98V78_gP-T4GttCG3SzdH9Vc0YXH328SvwKJJVRaTaKAmCYayrXZC%26name%3DDSMR%2BV4.0%2Bfinal%2BP1&ei=CHyeT5PgGc-VOs20-PsB&usg=AFQjCNE3sIY9JZ_RNEStaaA8YYv7iR0XkQ&sig2=PJXsfhIRCwWitgVgNrx2xQ) (also in docs directory)


Contributing to ParseP1
=====================
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
==========

Copyright (c) 2012 Frank Oxener - Agile Dovadi BV. See LICENSE.txt for further details.

