# including this Module will give you the power of postgres full text search 
# on an predefined postgres tsvector column
# the full_text_search_on methods exepts the name for the new full_test_serach scope
# options:
# :on the name of the tsvector column in your database
# :using (optional) the way individual words should be concatenated ("and" or "or") default "and"
#        using and each search term of the query must be found 
#       using or only on of the given search terms must be found
# :dictionary the dictunary used for the word steming on query default 'simple'
# the scope add a rank column that can be used to order the result 
# 
# E.g 
# class MyRecords
#  include FullTextSearch
#  full_text_search :search_by_description, :on => :description_vector, :using => "and", :dictionary => "german"
# end
module FullTextSearch
    def self.included(base)
      base.send(:extend, ClassMethods)
    end
  
  module ClassMethods
    # adds a full text scope
    def full_text_search(scope_name,options)
      logic = %w(| or ||).include?(options[:using].strip) ? "|" : "&"
      dict = options[:dictionary] || 'simple'
      field = options[:on]
      raise "you need ad least to tell me wich column to use for full_text_search" if field.blank?
      self.class_eval do
        scope scope_name, lambda { |str|
            str = str.strip.gsub(/[&!\|]/, '').gsub("'") { '\\'+$& }.gsub(/ +/, logic) 
            where("to_tsquery('#{dict}',E'#{str}') @@ #{field}").select("ts_rank(#{field},to_tsquery('#{dict}',E'#{str}')) AS rank,#{table_name}.*")
          }
      end
    end
  end
end