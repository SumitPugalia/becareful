# Becareful (Review, Review)

Erlang application for Behavioral Analytics of any product.

	Get Actionable insights on how users use your product

	Find out what are the major features that make users keep coming back.

Installation
------------
For the Project to successfully compile we require -

	Erlang OTP 20

About Becareful
---------------

	This is a analytical tool that can used by Marketing people of any organisation to analyse about the their product. They have to add events in the product at backend and can track the real time data.
	Nowadays,servers are distributed so "Becareful"	is built taking care of the same.
	It stores the data in each server(no replication) and while generating report it gathers data from all distributed nodes (servers).

Where To use Becareful
----------------------

	Can be used in messaging projects to track the number of messages, videos, group chats, gifs, images, files etc shared and analyse the amount of activity in the product.

	Can be useful in gaming servers to track the preference of users to play the type of game like tournament, simple play, play with friend etc, number of users that login through social media sites or play as guest users, number of bids, number of losses of bots etc.

	Can be used with any app to track which feature is used most by the users.

How to Use
----------

	Add this project as dependency.

	Add "becareful_api:send_event(EventName)" to track the event.

	Check number of events stored from http://localhost:4010/api-docs/index.html (act as dashboard).

Test
----

	./rebar3 as test shell
			becareful_api:send_event(message).  ## message is the eventname
			becareful_api:send_event(video).    ## video is the other event

	Browse 'http://localhost:4010/api-docs/index.html' and check the events stored.
	Samples can be checked in the images folder.		

	./rebar3 do ct --name ct@127.0.0.1, cover  
	(added distributed node test so we have to use -name option along with the ct command).

  |                 module  |  coverage  |
  |-------------------------|------------|
  |  event_manager_handler  |      100%  |
  |              becareful  |      100%  |
  |          becareful_sup  |      100%  |
  |           becareful_db  |       94%  |
  |          becareful_api  |       90%  |
  |        becareful_utils  |       93%  |
  |                  total  |       96%  |

Future Enhancement
------------------

	Add better UI piechart/barchart representation while generating the real time data.	
	
	Add Events for each user to analyse the behaviour of each user.
