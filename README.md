![Cursor_and_rafa_Rafaels-MacBook-Pro___repos_food_stand](https://user-images.githubusercontent.com/1904314/181935764-9d5f7d7e-1bca-4cea-9936-7b7a1e466e06.png)


### Assumptions

Note: some aspects were simplified for the purpose of keeping this exercise short.

- This is an end-user-facing API for searching for the closest place given a starting point and some filters
- The list of places is not big enough to cause performance issues
- The search is limited by exact match case insensitive
- The UI search form:
  - The text field for the starting point. e.g. `union square`
  - A text field to search for the closest place. e.g. `Japanese sandwiches`
  - Checkboxes for granular filtering. e.g. Facility Type: ["Truck", "Push Cart"], Open: [true, false]
  - Search button

### Code and API Design

#### Client-side request payload

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

You will notice the use of pure functions and encapsulation that facilitates maintainability.

I kept the implementation speed in mind but since I had no context on list size or performance constraints I decided to have a quick, functional, maintainable implementation at first, measure and optimize as needed later.
