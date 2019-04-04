class InterestSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :type, :selected
end
