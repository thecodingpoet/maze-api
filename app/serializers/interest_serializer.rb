class InterestSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :type
end
