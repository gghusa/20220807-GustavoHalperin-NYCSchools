# 20220807-GustavoHalperin-NYCSchools
NYC School list plus results Demo


This app has one model, the name class is `Model`, and is an `ObservableObject` class. Wich means
that eny SwiftUI View that has defined a `StateObject` of this kind model will react for each change
only if the view is rendering something that change and because of that the view change too.
Apple disencorage the use of ViewModel in the SwiftUI model, I think that the main reason is because
ViewModels can become tricky and can easly create retention circle memory if they have Observers to
Publishers. It any case, Apple recomend to have one model that is created in the App's struct and pass
it as `EnviromentObjet` to the subviews. So this is how I implemented in here as well.

All the interaction with the model `Model` happens in the main thread, this is a requirement because 
the SwiftUI `View`s can refresh their self on the main thread only, therefore the cahnges on the 
model `Model` must happens on the main threas too.

The Model is the one talking with the service `SchoolSrvr` that ask for the School directory and School results, 
this service respons in his own Serial `DispatchQueue` created by the `URLSession` constructor. I didn't
provide the main queue as a delegate because after the get the response from the server we still have
work to do that I rather do in the background, this work is not much, is just the decoding of the data, 
anyways, sounds better to do that in the background. Of course, the model will listen to the `SchoolSrvr` with
an Observer (and `Anycancelable` object) that will schedule the response in the main queue with the help of 
the operator `receive(on: options:)`.

There are two more models, `SchoolInfo` and `SchoolResults`, those models are `struct` `Codable` and
`Equatable`, and they are used for the responses related to School Directory and School Results.

When the app is loaded the app request a new Directory and shows a loading view in the meanwhile. After it gets
the list of schools the view is refreshed with the list.

Each time the user clicks on one of the School cells the app will present a School Result view, by default
this view shows a loading View, and at the same time that is presented check if the School results already exist,
otherwise, ask the model to fetch this info and as soon as it gets the info the view is refreshed, if there is 
any error, an alert view will be resented and the app will dismiss the School Results view back to the directory.

Testing:
I found it useful to write test cases for the directory and school results queries as well as test their decoding,
besides that, I couldn't find another useful test so that is all on this matter :-).
