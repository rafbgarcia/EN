## Food Stand

![food_stand](https://user-images.githubusercontent.com/1904314/181935764-9d5f7d7e-1bca-4cea-9936-7b7a1e466e06.png)

### Assumptions

- This functionality will be used by end-users for searching for the closest place to a given starting point
- Time and space constraints are being ignored as I don't have information such as throughput and dataset size. The code runs in O(n * m) - dataset size * destination filters size.
- The search is limited by exact match case insensitive
- The UI search form:
  - The text field for the starting point. e.g. `union square`
  - A text field to search for the closest place. e.g. `Japanese sandwiches`
  - Checkboxes for granular filtering. e.g. Facility Type: ["Truck", "Push Cart"], Open: [true, false]
  - Search button

### Code and API Design

#### Payload coming from the client

User searches for the open japanese truck food closest to union square

```json
{
  "origin": {
    "applicant__cont": "union square"
  },
  "destination": {
    "status__eq": "approved",
    "facilitytype__eq": "truck",
    "fooditems__cont": "japanese"
  }
}
```

#### Server response payload

```json
{
  "objectid": "1569152",
  "applicant": "Datam SF LLC dba Anzu To You",
  "facilitytype": "Truck",
  "...": "..."
}
```

#### Design decisions

I'm deliberately making the front-end knowledgeable about how to filter records to avoid overengineering as I don't know what's worth abstracting at this point.

For example: is it worth abstracting what is an open place or a food truck?

I'm leaving these decisions to be made in the future as the API gets used by developers.

The API is flexible and easily extensible by filtering records based on matchers (inspired by [Ransack](https://activerecord-hackery.github.io/ransack/getting-started/search-matches/)).

Non-handled matchers and data types raise errors instead of swallowing them for a better developer experience.

You will notice the use of pure functions and encapsulation that facilitates maintainability. The code is clean and clear with concise functions and meaningful names.

I kept performance in mind but without context on constraints, my focus was to build a quick, functional, and maintainable code. Measure and optimize as needed later.
