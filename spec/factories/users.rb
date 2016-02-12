FactoryGirl.define do
  factory :user do
    name       { 'John Doe' }
    last_name  { '' }
    avatar     { 'cat_image.jpg' }
  end
end
