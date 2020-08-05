# CarTrackCodeChallenge


## Build and Runtime Requirement
 - Xcode 11 or later
 - iOS 13 or later

## Configuring the Project
1. Launch terminal and change directory to project root directory.
2. Run 'pod install' command


## Written in Swift

This code challenge is written in Swift and utilizes RxSwift library.

## Application Architecture

Code architecture follows MVVM principles. 
LoginViewController, DetailViewController,  and MapViewController utilizes its viewModel to communicate user inputs / data.

ViewModels utilizes routers to manage the navigation and transitions between viewControllers.
Current exception to this is the transition to CountryNumberPickerViewController.
CountryNumberPickerViewController does not inherit from BaseViewController which is the parent of LoginViewController, DetailViewController & MapViewController. CountryNumberPickerViewController came from PhoneNumberKit framework.

SqliteDatabaseManager is a singleton that can verify if user's input matches with database.
SqliteDatabaseManager utilizes the wrapper framework SQLite.swift.
Database is stored at device's documents directory with the filename "users.sqlite3".

SqliteDatabaseManager first attempts to make a connection at said path. 
If load fails, the default users at "DefaultUsers.plist" are loaded.

Any errors on during database load process in displayed as toast message in LoginViewController.

- Validation is implemented on LoginViewModel canProceed: Observable<Bool>
- checks username, password, and country BehaviorRelays
- when any of those relays gets updated, the canProceed value is updated

## Other Features

- Dark Mode
- Skeleton view animation while fetching users
- Table reload animation
- Pagination implemented

## Unit Tests

- LoginViewModelTests tests canProceed value on different combination of inputs from userNameRelay, passwordRelay, and countryRelay

- SqliteDatabaseManagerTests tests loading the "DefaultUsers.plist" to the database

- DetailViewModelTests tests fetching users from "https://jsonplaceholder.typicode.com/users" endpoint

