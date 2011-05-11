# encoding: utf-8

Factory.define :book do |f|
  f.title { Faker::Lorem.sentence(3) }
end

Factory.define :publisher do |f|
  f.name { Faker::Lorem.sentence(2) }
end

Factory.define :author do |f|
  f.name { Faker::Name.last_name }
end
