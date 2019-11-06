FactoryBot.define do
  factory :parking do
    plate { FFaker::String.from_regexp(/\A[A-Z]{3}-[0-9]{4}\Z/) }
  end
end
