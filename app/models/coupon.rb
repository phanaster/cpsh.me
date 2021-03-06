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
 
  validates_presence_of :code , :message => " is empty : Hey, you forgot to add the code!"
  validates_presence_of :description, :message => " is empty : Do you Remember to add the Description? Me Neither."
  validates_presence_of :link, :message => " is empty : Please give us a hint where to go with this Coupon. Add the Link !"

  validates_numericality_of :expire_after_days
  validates_numericality_of :expire_after_views
end
