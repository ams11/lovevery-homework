# Lovevery Take Home Project

This is the take-home project for engineers at Lovevery, and thanks in advance for taking the time on this.  The
goal of this project is to try to simulate some real-world work you'll do as an engineer for us, so that we can
see you write some code from the comfort of your own computer.

## Submission Instructions

1. Please clone the repo into your own **private repo** in order to complete the assignment.
1. In addition to completing the implementation that the repo describes, please **edit this README** and provide one or two paragraphs explaining what you did, why, and how you tested it. You may include ideas for future enhancement, if you have anything to call out.
1. Share your private repo with the following email addresses when you're ready for us to take a look:

```
paul@lovevery.com
ola.mork@lovevery.com
charlie.maffitt@lovevery.com
grey@lovevery.com
yanny@lovevery.com
manisha@lovevery.com
```

## Updated Project to support gifting

The application now has support for gifting products: when viewing a product, a user now has an option to purchase it or to gift it. Internally, the functionality is quite similar - the purchase will still be associated with a product and a child and will require a sucessful credit card charge to be considered valid. In a production environment, the easiest solution may very well be to extend the `Order` model to support both regular orders and gifts. We'd still need to update the UI, such that the new gift page does not ask the customer to input an address and the corresponding controller logic will only look up an existing child (and get the shipping address from one of the gifts or orders associated with them), instead of optionally creating one, as [`OrdersController#create`](https://github.com/ams11/lovevery-homework/blob/48410e66febb0281524534971a3eba09861519b1/app/controllers/orders_controller.rb#L11) currently does. _However_, I also recall that the instructions were distinctly not to just add a `gift` boolean flag :) - I didn't fully understand it at the time, but it very much makes sense now. So, instead, I've added a new stand-alone [`Gift`](https://github.com/ams11/lovevery-homework/blob/master/app/models/gift.rb) model and a corresponding [`GiftsController`](https://github.com/ams11/lovevery-homework/blob/master/app/controllers/gifts_controller.rb), with similar routing to orders. Long term, this is likely a better solution anyway, as it gives us far more flexibility for the future when gifting products may very well diverge from ordering products more than it does now.

In the implementation, the logic for gifts and orders is quite similar, so I've tried to cut down on code duplication by sharing the logic between the two models and controllers. The [`Gift`](https://github.com/ams11/lovevery-homework/blob/master/app/models/gift.rb) and [`Order`](https://github.com/ams11/lovevery-homework/blob/master/app/models/order.rb) models now both inherit from the [`ProductPurchase`](https://github.com/ams11/lovevery-homework/blob/master/app/models/product_purchase.rb) parent model, which actually contains almost all of the model logic. The controllers could be optimized more to share code, for now, I've just pulled out some of the shared functionality into a [`PurchasesHelper`](https://github.com/ams11/lovevery-homework/blob/master/app/helpers/purchases_helper.rb) module. I've tried to pull out [at least some of] the duplicate view code into shared partials. Unfortunately, the database still ends up denormalized, with data duplicated between the `orders`, `gifts`, and `children` tables. In more of a real world scenario, if designing this from scratch, I'd consider consolidating the database data to avoid duplication. At the very least, I'd definitely want to pull out the address information into a separate `addresses` table, that the others could reference. Beyond that, we could also consider a [single table inheritance](https://en.wikipedia.org/wiki/Single_Table_Inheritance) structure for a table that could contain both orders and gifts, though while that would cut down on duplication of data, it would still leave the table denormalized (as a row representing an `Order` would still now contain a column for `gift_comment`).

It's also possible to implement a [polymorphic association](https://guides.rubyonrails.org/association_basics.html#polymorphic-associations) between the `Child` model and `Order`/`Gift` - so that a child could just have a common relationship of `purchasable` items, but that would require a larger re-architecture of the database, as we may have to reverse the relationship between the models, so I decieded not to pursue that option for now. I did add a [`purchases`](https://github.com/ams11/lovevery-homework/blob/48410e66febb0281524534971a3eba09861519b1/app/models/child.rb#L7-L9) method to the `Child` model, which accomplishes largely the same thing by returning a combined array of `Order`'s and `Gift`'s, but as it's computed in memory, it does not get the benfits and optimizations that an `ActiveRelation` would have provided.

Other considerations and potential improvements:
 - when creating a gift, we need to look up a child in the database. The lookup is currently exact and case sensitive - it would be nice to make it not case sensitive, but that would require updating the database structure again to save both the originally entered values, and a downcased version to use in lookups. In a real life scenario, we'd want to provide more feedback and validation that you'd found the right child, but I felt that was beyond the scope of the project here. We do currently provide errors when no child was found
 - when a child is found, we get the address from one of their previous orders or gifts. If there's a child in the database who does not have any orders or gifts already, a new gift cannot be created. The case where only a Gift exists (at some point an Order had to have existed too, but it may have been subsequently deleted) is supported.
 - I did add some improved error handling for both order and gift processing, it's still not exactly pretty :sweat_smile:
 - Added tests for all (I think? At least most?) of the new functionality I've added

