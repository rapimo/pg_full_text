## Postgres Full Text Search

including this Module will give you the power of postgres full text search 
on an predefined postgres tsvector column
the full_text_search_on methods exepts the name for the new full_test_serach scope

```
options:
:on the name of the tsvector column in your database
:using            (optional) the way individual words should be concatenated ("and" or "or") default "and"
                  using and each search term of the query must be found 
                  using or only on of the given search terms must be found
:dictionary       the dictunary used for the word steming on query default 'simple'
                  the scope add a rank column that can be used to order the result 
```

# Usage

```ruby
class Post < ActiveRecord::Base
 include FullTextSearch
 full_text_search :search_by_description, :on => :description_vector, 
                                          :using => "and", :dictionary => "german"
end
```

