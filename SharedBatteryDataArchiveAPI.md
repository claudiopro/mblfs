# Introduction #

The [Shared Battery Data Archive](http://burgos.emeraldion.it/mbl/) is a great repository for  Mac laptop battery data, that is free for anyone to lookup via a web interface.

Additionally, it offers a public API to developers who want to use battery data for their applications.

# API URIs #

The API entry point is the URI:
http://burgos.emeraldion.it/mbl/api/

To get the list of Mac laptop models available in the archive, use the following URI:
http://burgos.emeraldion.it/mbl/api/list/

To get the list of entries for a particular Mac laptop model `model`, use the following URI:
http://burgos.emeraldion.it/mbl/api/list/

&lt;model&gt;



To get the data for a particular entry, given its unique id `entry_id`, use the following URI:
http://burgos.emeraldion.it/mbl/api/entry/

<entry\_id>



# Examples #

Access the list of entries for model `MacBookPro4,1` at the following URI:
http://burgos.emeraldion.it/mbl/api/list/MacBookPro4,1

You can get the data for a the entry whose unique id is `117bfc3bc6255273f0815b7e08db502d` at the following URI:
http://burgos.emeraldion.it/mbl/api/entry/117bfc3bc6255273f0815b7e08db502d