# Web2Wave

Web2Wave is a Swift package that provides a simple interface for managing user subscriptions and properties through a REST API. It offers convenient methods to check subscription statuses and fetch user properties asynchronously.

## Features

- Fetch subscription status for users
- Check if a user has an active subscription
- Retrieve user properties
- Built with modern Swift async/await
- Singleton pattern for easy access
- Thread-safe with `@MainActor`

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "your-repository-url/Web2Wave.git", from: "1.0.0")
]
```

## Setup

Before using Web2Wave, you need to configure it with your base URL and API key:

```swift
// Initialize Web2Wave
Web2Wave.shared.baseURL = URL(string: "https://your-api-base-url.com")
Web2Wave.shared.apiKey = "your-api-key"
```

## Usage

### Checking Subscription Status

```swift
// Fetch detailed subscription status
let userID = "user123"
if let subscriptionStatus = await Web2Wave.shared.fetchSubscriptionStatus(userID: userID) {
    print("Subscription details: \(subscriptionStatus)")
}

// Check if user has active subscription
let isActive = await Web2Wave.shared.hasActiveSubscription(userID: userID)
if isActive {
    print("User has an active subscription")
} else {
    print("User does not have an active subscription")
}
```

### Fetching User Properties

```swift
let userID = "user123"
if let properties = await Web2Wave.shared.fetchUserProperties(userID: userID) {
    // Access individual properties
    if let userLevel = properties["user_level"] {
        print("User level: \(userLevel)")
    }
    
    // Print all properties
    for (key, value) in properties {
        print("\(key): \(value)")
    }
}
```

## Response Types

### Subscription Status Response

The subscription status endpoint returns a dictionary containing user information and subscription details:

```swift
{
    "user_id": "user123",
    "user_email": "user@example.com",
    "subscription": [
        {
            "status": "active",
            // other subscription fields
        }
    ]
}
```

### User Properties Response

The user properties endpoint returns an array of property key-value pairs:

```swift
{
    "properties": [
        {
            "property": "user_level",
            "value": "premium"
        }
    ]
}
```

## Error Handling

The package includes built-in error handling and will return `nil` in case of:
- Network errors
- Invalid API responses
- Missing or malformed data

Make sure to handle potential `nil` returns appropriately in your code:

```swift
if let subscriptionStatus = await Web2Wave.shared.fetchSubscriptionStatus(userID: userID) {
    // Handle successful response
} else {
    // Handle error case
}
```

## Requirements

- iOS 13.0+ / macOS 10.15+
- Swift 5.5+
- Xcode 13.0+

## Thread Safety

Web2Wave is designed to be thread-safe and uses `@MainActor` to ensure proper concurrency handling. All API calls are asynchronous and should be called using `await`.

## License

[Your chosen license]

## Author

Igor Kamenev

## Contributing

[Your contribution guidelines]
