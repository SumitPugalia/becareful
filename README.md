# Becareful

Erlang application for Behavioral Analytics of any product.

	Get Actionable insights on how users use your product

	Find out what are the major features that make users keep coming back.

Installation
------------
For the Project to successfully compile we require -

	Erlang OTP 20

How to Use
----------

	Add this project as dependency.

	Use "becareful_api:send_event(EventName)" to track the event from your backend code.

	Check number of events stored from http://localhost:4010/api-docs/ (act as dashboard).

Where To Use
------------

	Can be used in messaging projects to track the number of messages, videos, group chats, gifs, images, files etc shared and analyse the amount of activity in the product.

	Can be useful in gaming servers to track the preference of users to play the type of game like tournament, simple play, play with friend etc, number of users that login through social media sites or play as guest users, number of bids, number of losses of bots etc.

	Can be used with any app to track which feature is used most by the users.

About Becareful
---------------

	This is a analytical tool that can used by Marketing people of any organisation to analyse about the their product. They have to add events in the product at backend and can track the real time data.
	Nowadays,servers are distributed so "Becareful"	is built taking care of the same.
	It stores the data in each server(no replication) and while generating report it gathers data from all distributed nodes (servers).

Future Enhancement.
------------------

	Add Events for each user to analyse the behaviour of each user.
