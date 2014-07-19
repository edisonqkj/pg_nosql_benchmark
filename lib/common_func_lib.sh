#!/bin/bash

################################################################################
# Copyright EnterpriseDB Cooperation
# All rights reserved.
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright
#      notice, this list of conditions and the following disclaimer in
#      the documentation and/or other materials provided with the
#      distribution.
#    * Neither the name of PostgreSQL nor the names of its contributors
#      may be used to endorse or promote products derived from this
#      software without specific prior written permission.
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
#  Author: Vibhor Kumar
#  E-mail ID: vibhor.aim@gmail.com
################################################################################
# quit on any error
set -e
# verify any  undefined shell variables
set -u

################################################################################
# function: print messages with process id
################################################################################
function plog()
{
   echo "PID: $$ [RUNTIME: $(date +'%m-%d-%y %H:%M:%S')] ${BASENAME}: $*" >&2
}

################################################################################
# function: exit_error
################################################################################
function exit_error()
{

   plog "ERROR: $*"
   exit 1
 }

################################################################################
# function: print_info
################################################################################
function pinfo()
{
   plog ""
   plog "INFO: $*"
   plog ""
}

################################################################################
# function: exit_success
################################################################################
function exit_success()
{
   plog "SUCCESS: $*"
   exit 0
}

################################################################################
# function: if_error
################################################################################
function if_error
{
   typeset rc=$1
   shift
   typeset msg="$*"

   if [[ ${rc} -ne 0 ]]
   then
       exit_error "$msg; rc=${rc}"
   else
       return 0
   fi
}

################################################################################
# function: get_timestamp_in_nanoseconds
################################################################################
function get_timestamp_nano ()
{
    echo $(date +"%F %T.%N")
}


################################################################################
# function: get_timestamp_diff_nanoseconds
################################################################################
function get_timestamp_diff_nano ()
{
     typeset -r F_TIMESTAMP1="$1"
     typeset -r F_TIMESTAMP2="$2"
     local SECONDS_DIFF
     local NANOSECONDS_DIFF
     local SECONDS_NANO

     SECONDS_DIFF=$(echo $(date -d "${F_TIMESTAMP1}" +%s) \
                      -  $(date -d "${F_TIMESTAMP2}" +%s)|bc)
     NANOSECONDS_DIFF=$(echo $(date -d "${F_TIMESTAMP1}" +%N) \
                          -  $(date -d "${F_TIMESTAMP2}" +%N)|bc)
     SECONDS_NANO=$(echo ${SECONDS_DIFF} \* 1000000000|bc)
     printf "%d\n" $(((${SECONDS_NANO}  + ${NANOSECONDS_DIFF})))
}

################################################################################
# function: json_seed_data
################################################################################
function json_seed_data ()
{

     local INDX="$1"
     local SEED_DATA

     if [[ ${INDX} -eq 0 ]]
     then
         INDX=1
     fi
       SEED_DATA="{ \"name\" : \"AC3$((${RANDOM}/$INDX + $INDX )) Phone\", \"brand\" : \"ACME$((${RANDOM}/$INDX + $INDX ))\", \"type\" : \"phone\", \"price\" : 200, \"warranty_years\" : 1, \"available\" : true, \"description\": \"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin eget elit ut nulla tempor viverra vel eu nulla. Sed luctus porttitor urna, ac dapibus velit fringilla et. Donec iaculis, dolor a vehicula dictum, augue neque suscipit augue, nec mollis massa neque in libero. Donec sed dapibus magna. Pellentesque at condimentum dolor. In nunc nibh, dignissim in risus a, blandit tincidunt velit. Vestibulum rutrum tempus sem eget tempus. Mauris sollicitudin purus auctor dolor vestibulum, vitae pulvinar neque suscipit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Phasellus lacus turpis, vulputate at adipiscing viverra, ultricies at lectus. Pellentesque ut porta leo, vel eleifend neque. Nunc sagittis metus at ante pellentesque, ut condimentum libero semper. In hac habitasse platea dictumst. In dapibus posuere posuere. Fusce vulputate augue eget tellus molestie, vitae egestas ante malesuada. Phasellus nunc mi, faucibus at elementum pharetra, aliquet a enim. In purus est, vulputate in nibh quis, faucibus dapibus magna. In accumsan libero velit, eu accumsan sem commodo id. In fringilla tempor augue, et feugiat erat convallis et. Sed aliquet eget ipsum eu vestibulum.Curabitur blandit leo nec condimentum semper. Mauris lectus sapien, rutrum a tincidunt id, euismod ac elit. Mauris suscipit et arcu et auctor. Quisque mollis magna vel mi viverra rutrum. Nulla non pretium magna. Cras sed tortor non tellus rutrum gravida eu at odio. Aliquam cursus fermentum erat, nec ullamcorper sem gravida sit amet. Donec viverra, erat vel ornare pulvinar, est ipsum accumsan massa, eu tristique lorem ante nec tortor. Sed suscipit iaculis faucibus. Maecenas a suscipit ligula, vitae faucibus turpis.Cras sed tellus auctor, tempor leo eu, molestie leo. Suspendisse ipsum tellus, egestas et ultricies eu, tempus a arcu. Cras laoreet, est dapibus consequat varius, nisi nisi placerat leo, et dictum ante tortor vitae est. Duis eu urna ac felis ullamcorper rutrum. Quisque iaculis, enim eget sodales vehicula, magna orci dignissim eros, nec volutpat massa urna in elit. In interdum pellentesque risus, feugiat pulvinar odio eleifend sit amet. Quisque congue libero quis dolor faucibus, a mollis nisl tempus.\" }
{ \"name\" : \"AC7$((${RANDOM}/$INDX + $INDX )) Phone\", \"brand\" : \"ACME\", \"type\" : \"phone\", \"price\" : 320, \"warranty_years\" : 1, \"available\" : false, \"description\":\"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin eget elit ut nulla tempor viverra vel eu nulla. Sed luctus porttitor urna, ac dapibus velit fringilla et. Donec iaculis, dolor a vehicula dictum, augue neque suscipit augue, nec mollis massa neque in libero. Donec sed dapibus magna. Pellentesque at condimentum dolor. In nunc nibh, dignissim in risus a, blandit tincidunt velit. Vestibulum rutrum tempus sem eget tempus. Mauris sollicitudin purus auctor dolor vestibulum, vitae pulvinar neque suscipit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Phasellus lacus turpis, vulputate at adipiscing viverra, ultricies at lectus. Pellentesque ut porta leo, vel eleifend neque. Nunc sagittis metus at ante pellentesque, ut condimentum libero semper. In hac habitasse platea dictumst. In dapibus posuere posuere. Fusce vulputate augue eget tellus molestie, vitae egestas ante malesuada. Phasellus nunc mi, faucibus at elementum pharetra, aliquet a enim. In purus est, vulputate in nibh quis, faucibus dapibus magna. In accumsan libero velit, eu accumsan sem commodo id. In fringilla tempor augue, et feugiat erat convallis et. Sed aliquet eget ipsum eu vestibulum.Curabitur blandit leo nec condimentum semper. Mauris lectus sapien, rutrum a tincidunt id, euismod ac elit. Mauris suscipit et arcu et auctor. Quisque mollis magna vel mi viverra rutrum. Nulla non pretium magna. Cras sed tortor non tellus rutrum gravida eu at odio. Aliquam cursus fermentum erat, nec ullamcorper sem gravida sit amet. Donec viverra, erat vel ornare pulvinar, est ipsum accumsan massa, eu tristique lorem ante nec tortor. Sed suscipit iaculis faucibus. Maecenas a suscipit ligula, vitae faucibus turpis.Cras sed tellus auctor, tempor leo eu, molestie leo. Suspendisse ipsum tellus, egestas et ultricies eu, tempus a arcu. Cras laoreet, est dapibus consequat varius, nisi nisi placerat leo, et dictum ante tortor vitae est. Duis eu urna ac felis ullamcorper rutrum. Quisque iaculis, enim eget sodales vehicula, magna orci dignissim eros, nec volutpat massa urna in elit. In interdum pellentesque risus, feugiat pulvinar odio eleifend sit amet. Quisque congue libero quis dolor faucibus, a mollis nisl tempus.\" }
{ \"name\" : \"AC3$((${RANDOM}/$INDX + $INDX )) Series Charger\", \"type\" : [ \"accessory\", \"charger\" ], \"price\" : 19, \"warranty_years\" : 0.25, \"for\" : [ \"ac3\", \"ac7\", \"ac9\" ], \"description\": \"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin eget elit ut nulla tempor viverra vel eu nulla. Sed luctus porttitor urna, ac dapibus velit fringilla et. Donec iaculis, dolor a vehicula dictum, augue neque suscipit augue, nec mollis massa neque in libero. Donec sed dapibus magna. Pellentesque at condimentum dolor. In nunc nibh, dignissim in risus a, blandit tincidunt velit. Vestibulum rutrum tempus sem eget tempus. Mauris sollicitudin purus auctor dolor vestibulum, vitae pulvinar neque suscipit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Phasellus lacus turpis, vulputate at adipiscing viverra, ultricies at lectus. Pellentesque ut porta leo, vel eleifend neque. Nunc sagittis metus at ante pellentesque, ut condimentum libero semper. In hac habitasse platea dictumst. In dapibus posuere posuere. Fusce vulputate augue eget tellus molestie, vitae egestas ante malesuada. Phasellus nunc mi, faucibus at elementum pharetra, aliquet a enim. In purus est, vulputate in nibh quis, faucibus dapibus magna. In accumsan libero velit, eu accumsan sem commodo id. In fringilla tempor augue, et feugiat erat convallis et. Sed aliquet eget ipsum eu vestibulum.Curabitur blandit leo nec condimentum semper. Mauris lectus sapien, rutrum a tincidunt id, euismod ac elit. Mauris suscipit et arcu et auctor. Quisque mollis magna vel mi viverra rutrum. Nulla non pretium magna. Cras sed tortor non tellus rutrum gravida eu at odio. Aliquam cursus fermentum erat, nec ullamcorper sem gravida sit amet. Donec viverra, erat vel ornare pulvinar, est ipsum accumsan massa, eu tristique lorem ante nec tortor. Sed suscipit iaculis faucibus. Maecenas a suscipit ligula, vitae faucibus turpis.Cras sed tellus auctor, tempor leo eu, molestie leo. Suspendisse ipsum tellus, egestas et ultricies eu, tempus a arcu. Cras laoreet, est dapibus consequat varius, nisi nisi placerat leo, et dictum ante tortor vitae est. Duis eu urna ac felis ullamcorper rutrum. Quisque iaculis, enim eget sodales vehicula, magna orci dignissim eros, nec volutpat massa urna in elit. In interdum pellentesque risus, feugiat pulvinar odio eleifend sit amet. Quisque congue libero quis dolor faucibus, a mollis nisl tempus.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin eget elit ut nulla tempor viverra vel eu nulla. Sed luctus porttitor urna, ac dapibus velit fringilla et. Donec iaculis, dolor a vehicula dictum, augue neque suscipit augue, nec mollis massa neque in libero. Donec sed dapibus magna. Pellentesque at condimentum dolor. In nunc nibh, dignissim in risus a, blandit tincidunt velit. Vestibulum rutrum tempus sem eget tempus. Mauris sollicitudin purus auctor dolor vestibulum, vitae pulvinar neque suscipit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Phasellus lacus turpis, vulputate at adipiscing viverra, ultricies at lectus. Pellentesque ut porta leo, vel eleifend neque. Nunc sagittis metus at ante pellentesque, ut condimentum libero semper. In hac habitasse platea dictumst. In dapibus posuere posuere. Fusce vulputate augue eget tellus molestie, vitae egestas ante malesuada. Phasellus nunc mi, faucibus at elementum pharetra, aliquet a enim. In purus est, vulputate in nibh quis, faucibus dapibus magna. In accumsan libero velit, eu accumsan sem commodo id. In fringilla tempor augue, et feugiat erat convallis et. Sed aliquet eget ipsum eu vestibulum.Curabitur blandit leo nec condimentum semper. Mauris lectus sapien, rutrum a tincidunt id, euismod ac elit. Mauris suscipit et arcu et auctor. Quisque mollis magna vel mi viverra rutrum. Nulla non pretium magna. Cras sed tortor non tellus rutrum gravida eu at odio. Aliquam cursus fermentum erat, nec ullamcorper sem gravida sit amet. Donec viverra, erat vel ornare pulvinar, est ipsum accumsan massa, eu tristique lorem ante nec tortor. Sed suscipit iaculis faucibus. Maecenas a suscipit ligula, vitae faucibus turpis.Cras sed tellus auctor, tempor leo eu, molestie leo. Suspendisse ipsum tellus, egestas et ultricies eu, tempus a arcu. Cras laoreet, est dapibus consequat varius, nisi nisi placerat leo, et dictum ante tortor vitae est. Duis eu urna ac felis ullamcorper rutrum. Quisque iaculis, enim eget sodales vehicula, magna orci dignissim eros, nec volutpat massa urna in elit. In interdum pellentesque risus, feugiat pulvinar odio eleifend sit amet. Quisque congue libero quis dolor faucibus, a mollis nisl tempus.\" }
{ \"name\" : \"AC3$((${RANDOM}/$INDX + $INDX )) Case Green\", \"type\" : [ \"accessory\", \"case\" ], \"color\" : \"green\", \"price\" : 12, \"warranty_years\" : 0, \"description\": \"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin eget elit ut nulla tempor viverra vel eu nulla. Sed luctus porttitor urna, ac dapibus velit fringilla et. Donec iaculis, dolor a vehicula dictum, augue neque suscipit augue, nec mollis massa neque in libero. Donec sed dapibus magna. Pellentesque at condimentum dolor. In nunc nibh, dignissim in risus a, blandit tincidunt velit. Vestibulum rutrum tempus sem eget tempus. Mauris sollicitudin purus auctor dolor vestibulum, vitae pulvinar neque suscipit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Phasellus lacus turpis, vulputate at adipiscing viverra, ultricies at lectus. Pellentesque ut porta leo, vel eleifend neque. Nunc sagittis metus at ante pellentesque, ut condimentum libero semper. In hac habitasse platea dictumst. In dapibus posuere posuere. Fusce vulputate augue eget tellus molestie, vitae egestas ante malesuada. Phasellus nunc mi, faucibus at elementum pharetra, aliquet a enim. In purus est, vulputate in nibh quis, faucibus dapibus magna. In accumsan libero velit, eu accumsan sem commodo id. In fringilla tempor augue, et feugiat erat convallis et. Sed aliquet eget ipsum eu vestibulum.Curabitur blandit leo nec condimentum semper. Mauris lectus sapien, rutrum a tincidunt id, euismod ac elit. Mauris suscipit et arcu et auctor. Quisque mollis magna vel mi viverra rutrum. Nulla non pretium magna. Cras sed tortor non tellus rutrum gravida eu at odio. Aliquam cursus fermentum erat, nec ullamcorper sem gravida sit amet. Donec viverra, erat vel ornare pulvinar, est ipsum accumsan massa, eu tristique lorem ante nec tortor. Sed suscipit iaculis faucibus. Maecenas a suscipit ligula, vitae faucibus turpis.Cras sed tellus auctor, tempor leo eu, molestie leo. Suspendisse ipsum tellus, egestas et ultricies eu, tempus a arcu. Cras laoreet, est dapibus consequat varius, nisi nisi placerat leo, et dictum ante tortor vitae est. Duis eu urna ac felis ullamcorper rutrum. Quisque iaculis, enim eget sodales vehicula, magna orci dignissim eros, nec volutpat massa urna in elit. In interdum pellentesque risus, feugiat pulvinar odio eleifend sit amet. Quisque congue libero quis dolor faucibus, a mollis nisl tempus.\" }
{ \"name\" : \"Phone Extended Warranty\", \"type\" : \"warranty\", \"price\" : 38, \"warranty_years\" : 2, \"for\" : [ \"ac3\", \"ac7\", \"ac9\", \"qp7\", \"qp8\", \"qp9\" ], \"description\": \"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin eget elit ut nulla tempor viverra vel eu nulla. Sed luctus porttitor urna, ac dapibus velit fringilla et. Donec iaculis, dolor a vehicula dictum, augue neque suscipit augue, nec mollis massa neque in libero. Donec sed dapibus magna. Pellentesque at condimentum dolor. In nunc nibh, dignissim in risus a, blandit tincidunt velit. Vestibulum rutrum tempus sem eget tempus. Mauris sollicitudin purus auctor dolor vestibulum, vitae pulvinar neque suscipit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Phasellus lacus turpis, vulputate at adipiscing viverra, ultricies at lectus. Pellentesque ut porta leo, vel eleifend neque. Nunc sagittis metus at ante pellentesque, ut condimentum libero semper. In hac habitasse platea dictumst. In dapibus posuere posuere. Fusce vulputate augue eget tellus molestie, vitae egestas ante malesuada. Phasellus nunc mi, faucibus at elementum pharetra, aliquet a enim. In purus est, vulputate in nibh quis, faucibus dapibus magna. In accumsan libero velit, eu accumsan sem commodo id. In fringilla tempor augue, et feugiat erat convallis et. Sed aliquet eget ipsum eu vestibulum.Curabitur blandit leo nec condimentum semper. Mauris lectus sapien, rutrum a tincidunt id, euismod ac elit. Mauris suscipit et arcu et auctor. Quisque mollis magna vel mi viverra rutrum. Nulla non pretium magna. Cras sed tortor non tellus rutrum gravida eu at odio. Aliquam cursus fermentum erat, nec ullamcorper sem gravida sit amet. Donec viverra, erat vel ornare pulvinar, est ipsum accumsan massa, eu tristique lorem ante nec tortor. Sed suscipit iaculis faucibus. Maecenas a suscipit ligula, vitae faucibus turpis.Cras sed tellus auctor, tempor leo eu, molestie leo. Suspendisse ipsum tellus, egestas et ultricies eu, tempus a arcu. Cras laoreet, est dapibus consequat varius, nisi nisi placerat leo, et dictum ante tortor vitae est. Duis eu urna ac felis ullamcorper rutrum. Quisque iaculis, enim eget sodales vehicula, magna orci dignissim eros, nec volutpat massa urna in elit. In interdum pellentesque risus, feugiat pulvinar odio eleifend sit amet. Quisque congue libero quis dolor faucibus, a mollis nisl tempus.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin eget elit ut nulla tempor viverra vel eu nulla. Sed luctus porttitor urna, ac dapibus velit fringilla et. Donec iaculis, dolor a vehicula dictum, augue neque suscipit augue, nec mollis massa neque in libero. Donec sed dapibus magna. Pellentesque at condimentum dolor. In nunc nibh, dignissim in risus a, blandit tincidunt velit. Vestibulum rutrum tempus sem eget tempus. Mauris sollicitudin purus auctor dolor vestibulum, vitae pulvinar neque suscipit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Phasellus lacus turpis, vulputate at adipiscing viverra, ultricies at lectus. Pellentesque ut porta leo, vel eleifend neque. Nunc sagittis metus at ante pellentesque, ut condimentum libero semper. In hac habitasse platea dictumst. In dapibus posuere posuere. Fusce vulputate augue eget tellus molestie, vitae egestas ante malesuada. Phasellus nunc mi, faucibus at elementum pharetra, aliquet a enim. In purus est, vulputate in nibh quis, faucibus dapibus magna. In accumsan libero velit, eu accumsan sem commodo id. In fringilla tempor augue, et feugiat erat convallis et. Sed aliquet eget ipsum eu vestibulum.Curabitur blandit leo nec condimentum semper. Mauris lectus sapien, rutrum a tincidunt id, euismod ac elit. Mauris suscipit et arcu et auctor. Quisque mollis magna vel mi viverra rutrum. Nulla non pretium magna. Cras sed tortor non tellus rutrum gravida eu at odio. Aliquam cursus fermentum erat, nec ullamcorper sem gravida sit amet. Donec viverra, erat vel ornare pulvinar, est ipsum accumsan massa, eu tristique lorem ante nec tortor. Sed suscipit iaculis faucibus. Maecenas a suscipit ligula, vitae faucibus turpis.Cras sed tellus auctor, tempor leo eu, molestie leo. Suspendisse ipsum tellus, egestas et ultricies eu, tempus a arcu. Cras laoreet, est dapibus consequat varius, nisi nisi placerat leo, et dictum ante tortor vitae est. Duis eu urna ac felis ullamcorper rutrum. Quisque iaculis, enim eget sodales vehicula, magna orci dignissim eros, nec volutpat massa urna in elit. In interdum pellentesque risus, feugiat pulvinar odio eleifend sit amet. Quisque congue libero quis dolor faucibus, a mollis nisl tempus.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin eget elit ut nulla tempor viverra vel eu nulla. Sed luctus porttitor urna, ac dapibus velit fringilla et. Donec iaculis, dolor a vehicula dictum, augue neque suscipit augue, nec mollis massa neque in libero. Donec sed dapibus magna. Pellentesque at condimentum dolor. In nunc nibh, dignissim in risus a, blandit tincidunt velit. Vestibulum rutrum tempus sem eget tempus. Mauris sollicitudin purus auctor dolor vestibulum, vitae pulvinar neque suscipit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Phasellus lacus turpis, vulputate at adipiscing viverra, ultricies at lectus. Pellentesque ut porta leo, vel eleifend neque. Nunc sagittis metus at ante pellentesque, ut condimentum libero semper. In hac habitasse platea dictumst. In dapibus posuere posuere. Fusce vulputate augue eget tellus molestie, vitae egestas ante malesuada. Phasellus nunc mi, faucibus at elementum pharetra, aliquet a enim. In purus est, vulputate in nibh quis, faucibus dapibus magna. In accumsan libero velit, eu accumsan sem commodo id. In fringilla tempor augue, et feugiat erat convallis et. Sed aliquet eget ipsum eu vestibulum.Curabitur blandit leo nec condimentum semper. Mauris lectus sapien, rutrum a tincidunt id, euismod ac elit. Mauris suscipit et arcu et auctor. Quisque mollis magna vel mi viverra rutrum. Nulla non pretium magna. Cras sed tortor non tellus rutrum gravida eu at odio. Aliquam cursus fermentum erat, nec ullamcorper sem gravida sit amet. Donec viverra, erat vel ornare pulvinar, est ipsum accumsan massa, eu tristique lorem ante nec tortor. Sed suscipit iaculis faucibus. Maecenas a suscipit ligula, vitae faucibus turpis.Cras sed tellus auctor, tempor leo eu, molestie leo. Suspendisse ipsum tellus, egestas et ultricies eu, tempus a arcu. Cras laoreet, est dapibus consequat varius, nisi nisi placerat leo, et dictum ante tortor vitae est. Duis eu urna ac felis ullamcorper rutrum. Quisque iaculis, enim eget sodales vehicula, magna orci dignissim eros, nec volutpat massa urna in elit. In interdum pellentesque risus, feugiat pulvinar odio eleifend sit amet. Quisque congue libero quis dolor faucibus, a mollis nisl tempus.\" }
{ \"name\" : \"AC3$((${RANDOM}/$INDX + $INDX )) Case Black\", \"type\" : [ \"accessory\", \"case\" ], \"color\" : \"black\", \"price\" : 12.5, \"warranty_years\" : 0.25, \"available\" : false, \"for\" : \"ac3\", \"description\":\"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin eget elit ut nulla tempor viverra vel eu nulla. Sed luctus porttitor urna, ac dapibus velit fringilla et. Donec iaculis, dolor a vehicula dictum, augue neque suscipit augue, nec mollis massa neque in libero. Donec sed dapibus magna. Pellentesque at condimentum dolor. In nunc nibh, dignissim in risus a, blandit tincidunt velit. Vestibulum rutrum tempus sem eget tempus. Mauris sollicitudin purus auctor dolor vestibulum, vitae pulvinar neque suscipit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Phasellus lacus turpis, vulputate at adipiscing viverra, ultricies at lectus. Pellentesque ut porta leo, vel eleifend neque. Nunc sagittis metus at ante pellentesque, ut condimentum libero semper. In hac habitasse platea dictumst. In dapibus posuere posuere. Fusce vulputate augue eget tellus molestie, vitae egestas ante malesuada. Phasellus nunc mi, faucibus at elementum pharetra, aliquet a enim. In purus est, vulputate in nibh quis, faucibus dapibus magna. In accumsan libero velit, eu accumsan sem commodo id. In fringilla tempor augue, et feugiat erat convallis et. Sed aliquet eget ipsum eu vestibulum.Curabitur blandit leo nec condimentum semper. Mauris lectus sapien, rutrum a tincidunt id, euismod ac elit. Mauris suscipit et arcu et auctor. Quisque mollis magna vel mi viverra rutrum. Nulla non pretium magna. Cras sed tortor non tellus rutrum gravida eu at odio. Aliquam cursus fermentum erat, nec ullamcorper sem gravida sit amet. Donec viverra, erat vel ornare pulvinar, est ipsum accumsan massa, eu tristique lorem ante nec tortor. Sed suscipit iaculis faucibus. Maecenas a suscipit ligula, vitae faucibus turpis.Cras sed tellus auctor, tempor leo eu, molestie leo. Suspendisse ipsum tellus, egestas et ultricies eu, tempus a arcu. Cras laoreet, est dapibus consequat varius, nisi nisi placerat leo, et dictum ante tortor vitae est. Duis eu urna ac felis ullamcorper rutrum. Quisque iaculis, enim eget sodales vehicula, magna orci dignissim eros, nec volutpat massa urna in elit. In interdum pellentesque risus, feugiat pulvinar odio eleifend sit amet. Quisque congue libero quis dolor faucibus, a mollis nisl tempus.\" }
{ \"name\" : \"AC3 Case Red\", \"type\" : [ \"accessory\", \"case\" ], \"color\" : \"red\", \"price\" : 12, \"warranty_years\" : 0.25, \"available\" : true, \"for\" : \"ac3\" }
{ \"name\" : \"Phone Service Basic Plan$((${RANDOM}/$INDX + $INDX ))\", \"type\" : \"service$((${RANDOM}/$INDX + $INDX ))\", \"monthly_price\" : 40, \"limits\" : { \"voice\" : { \"units\" : \"minutes\", \"n\" : 400, \"over_rate\" : 0.05 }, \"data\" : { \"units\" : \"gigabytes\", \"n\" : 20, \"over_rate\" : 1 }, \"sms\" : { \"units\" : \"texts sent\", \"n\" : 100, \"over_rate\" : 0.001 } }, \"term_years\" : 2 }
{ \"name\" : \"Phone Service Core Plan\", \"type\" : \"service$((${RANDOM}/$INDX + $INDX ))\", \"monthly_price\" : 60, \"limits\" : { \"voice\" : { \"units\" : \"minutes\", \"n\" : 1000, \"over_rate\" : 0.05 }, \"data\" : { \"n\" : \"unlimited\", \"over_rate\" : 0 }, \"sms\" : { \"n\" : \"unlimited\", \"over_rate\" : 0 } }, \"term_years\" : 1, \"description\": \"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin eget elit ut nulla tempor viverra vel eu nulla. Sed luctus porttitor urna, ac dapibus velit fringilla et. Donec iaculis, dolor a vehicula dictum, augue neque suscipit augue, nec mollis massa neque in libero. Donec sed dapibus magna. Pellentesque at condimentum dolor. In nunc nibh, dignissim in risus a, blandit tincidunt velit. Vestibulum rutrum tempus sem eget tempus. Mauris sollicitudin purus auctor dolor vestibulum, vitae pulvinar neque suscipit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Phasellus lacus turpis, vulputate at adipiscing viverra, ultricies at lectus. Pellentesque ut porta leo, vel eleifend neque. Nunc sagittis metus at ante pellentesque, ut condimentum libero semper. In hac habitasse platea dictumst. In dapibus posuere posuere. Fusce vulputate augue eget tellus molestie, vitae egestas ante malesuada. Phasellus nunc mi, faucibus at elementum pharetra, aliquet a enim. In purus est, vulputate in nibh quis, faucibus dapibus magna. In accumsan libero velit, eu accumsan sem commodo id. In fringilla tempor augue, et feugiat erat convallis et. Sed aliquet eget ipsum eu vestibulum.Curabitur blandit leo nec condimentum semper. Mauris lectus sapien, rutrum a tincidunt id, euismod ac elit. Mauris suscipit et arcu et auctor. Quisque mollis magna vel mi viverra rutrum. Nulla non pretium magna. Cras sed tortor non tellus rutrum gravida eu at odio. Aliquam cursus fermentum erat, nec ullamcorper sem gravida sit amet. Donec viverra, erat vel ornare pulvinar, est ipsum accumsan massa, eu tristique lorem ante nec tortor. Sed suscipit iaculis faucibus. Maecenas a suscipit ligula, vitae faucibus turpis.Cras sed tellus auctor, tempor leo eu, molestie leo. Suspendisse ipsum tellus, egestas et ultricies eu, tempus a arcu. Cras laoreet, est dapibus consequat varius, nisi nisi placerat leo, et dictum ante tortor vitae est. Duis eu urna ac felis ullamcorper rutrum. Quisque iaculis, enim eget sodales vehicula, magna orci dignissim eros, nec volutpat massa urna in elit. In interdum pellentesque risus, feugiat pulvinar odio eleifend sit amet. Quisque congue libero quis dolor faucibus, a mollis nisl tempus.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin eget elit ut nulla tempor viverra vel eu nulla. Sed luctus porttitor urna, ac dapibus velit fringilla et. Donec iaculis, dolor a vehicula dictum, augue neque suscipit augue, nec mollis massa neque in libero. Donec sed dapibus magna. Pellentesque at condimentum dolor. In nunc nibh, dignissim in risus a, blandit tincidunt velit. Vestibulum rutrum tempus sem eget tempus. Mauris sollicitudin purus auctor dolor vestibulum, vitae pulvinar neque suscipit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Phasellus lacus turpis, vulputate at adipiscing viverra, ultricies at lectus. Pellentesque ut porta leo, vel eleifend neque. Nunc sagittis metus at ante pellentesque, ut condimentum libero semper. In hac habitasse platea dictumst. In dapibus posuere posuere. Fusce vulputate augue eget tellus molestie, vitae egestas ante malesuada. Phasellus nunc mi, faucibus at elementum pharetra, aliquet a enim. In purus est, vulputate in nibh quis, faucibus dapibus magna. In accumsan libero velit, eu accumsan sem commodo id. In fringilla tempor augue, et feugiat erat convallis et. Sed aliquet eget ipsum eu vestibulum.Curabitur blandit leo nec condimentum semper. Mauris lectus sapien, rutrum a tincidunt id, euismod ac elit. Mauris suscipit et arcu et auctor. Quisque mollis magna vel mi viverra rutrum. Nulla non pretium magna. Cras sed tortor non tellus rutrum gravida eu at odio. Aliquam cursus fermentum erat, nec ullamcorper sem gravida sit amet. Donec viverra, erat vel ornare pulvinar, est ipsum accumsan massa, eu tristique lorem ante nec tortor. Sed suscipit iaculis faucibus. Maecenas a suscipit ligula, vitae faucibus turpis.Cras sed tellus auctor, tempor leo eu, molestie leo. Suspendisse ipsum tellus, egestas et ultricies eu, tempus a arcu. Cras laoreet, est dapibus consequat varius, nisi nisi placerat leo, et dictum ante tortor vitae est. Duis eu urna ac felis ullamcorper rutrum. Quisque iaculis, enim eget sodales vehicula, magna orci dignissim eros, nec volutpat massa urna in elit. In interdum pellentesque risus, feugiat pulvinar odio eleifend sit amet. Quisque congue libero quis dolor faucibus, a mollis nisl tempus.\"}
{ \"name\" : \"Phone Service Family Plan\", \"type\" : \"service\", \"monthly_price\" : 90, \"limits\" : { \"voice\" : { \"units\" : \"minutes\", \"n\" : 1200, \"over_rate\" : 0.05 }, \"data\" : { \"n\" : \"unlimited\", \"over_rate\" : 0 }, \"sms\" : { \"n\" : \"unlimited\", \"over_rate\" : 0 } }, \"sales_tax\" : true, \"term_years\" : 2 }
{ \"name\" : \"Cable TV Basic Service Package\", \"type\" : \"tv\", \"monthly_price\" : 50, \"term_years\" : 2, \"cancel_penalty\" : 25, \"sales_tax\" : true, \"additional_tarriffs\" : [ { \"kind\" : \"federal tarriff\", \"amount\" : { \"percent_of_service\" : 0.06 } }, { \"kind\" : \"misc tarriff\", \"amount\" : 2.25 } ], \"description\":\"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin eget elit ut nulla tempor viverra vel eu nulla. Sed luctus porttitor urna, ac dapibus velit fringilla et. Donec iaculis, dolor a vehicula dictum, augue neque suscipit augue, nec mollis massa neque in libero. Donec sed dapibus magna. Pellentesque at condimentum dolor. In nunc nibh, dignissim in risus a, blandit tincidunt velit. Vestibulum rutrum tempus sem eget tempus. Mauris sollicitudin purus auctor dolor vestibulum, vitae pulvinar neque suscipit. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Phasellus lacus turpis, vulputate at adipiscing viverra, ultricies at lectus. Pellentesque ut porta leo, vel eleifend neque. Nunc sagittis metus at ante pellentesque, ut condimentum libero semper. In hac habitasse platea dictumst. In dapibus posuere posuere. Fusce vulputate augue eget tellus molestie, vitae egestas ante malesuada. Phasellus nunc mi, faucibus at elementum pharetra, aliquet a enim. In purus est, vulputate in nibh quis, faucibus dapibus magna. In accumsan libero velit, eu accumsan sem commodo id. In fringilla tempor augue, et feugiat erat convallis et. Sed aliquet eget ipsum eu vestibulum.Curabitur blandit leo nec condimentum semper. Mauris lectus sapien, rutrum a tincidunt id, euismod ac elit. Mauris suscipit et arcu et auctor. Quisque mollis magna vel mi viverra rutrum. Nulla non pretium magna. Cras sed tortor non tellus rutrum gravida eu at odio. Aliquam cursus fermentum erat, nec ullamcorper sem gravida sit amet. Donec viverra, erat vel ornare pulvinar, est ipsum accumsan massa, eu tristique lorem ante nec tortor. Sed suscipit iaculis faucibus. Maecenas a suscipit ligula, vitae faucibus turpis.Cras sed tellus auctor, tempor leo eu, molestie leo. Suspendisse ipsum tellus, egestas et ultricies eu, tempus a arcu. Cras laoreet, est dapibus consequat varius, nisi nisi placerat leo, et dictum ante tortor vitae est. Duis eu urna ac felis ullamcorper rutrum. Quisque iaculis, enim eget sodales vehicula, magna orci dignissim eros, nec volutpat massa urna in elit. In interdum pellentesque risus, feugiat pulvinar odio eleifend sit amet. Quisque congue libero quis dolor faucibus, a mollis nisl tempus.\" }"

  echo "${SEED_DATA}"
}

################################################################################
# function: generate_json_data
################################################################################
function generate_json_rows ()
{
   typeset -r NO_OF_ROWS="$1"
   typeset -r FILENAME="$2"

   rm -rf ${FILENAME}
   plog "creating json data."
   NO_OF_LOOPS=$((${NO_OF_ROWS}/11 + 1 ))
   for ((i=0;i<${NO_OF_LOOPS};i++))
   do
       json_seed_data $i >>${FILENAME}
   done
}

################################################################################
# print integer arrays
################################################################################
function print_result()
{
   typeset -r F_TAG="$1"
   shift
   typeset -r F_LOCALARRAY=(${@})
   typeset F_ARRAYLENGTH

   F_ARRAYLENGTH=${#F_LOCALARRAY[@]}
   printf "%20s " "${F_TAG}"
   for (( i=0 ; i < ${F_ARRAYLENGTH} ; i++ ))
   do
      printf "%14d " ${F_LOCALARRAY[${i}]}
   done
   printf "\n"
}
