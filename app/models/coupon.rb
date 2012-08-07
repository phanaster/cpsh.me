class Coupon 
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MultiParameterAttributes


  field :code, type: String
  field :description, type: String
  field :link, type: String
  field :expired, type: Boolean, default: false
  field :expire_after_days, type: Integer
  field :expire_after_views, type: Integer
  field :boolean, type: Boolean, default: false
  field :viewcount, type: Integer ,default: 0
  field :url_token, type: String
  field :timestamps		
 
end
