when HTTP_REQUEST {
   if { ![class match [IP::client_addr] equals "private_net"] } {
   
     log local0. "Client IP:[IP::client_addr] is external so going to Green node"
   
   node 	10.1.10.100 9080
   
   } else {
   
   log local0. "Client IP:[IP::client_addr] is internal so will be load balanced"
   
   pool web_pool
   
   }
   
}