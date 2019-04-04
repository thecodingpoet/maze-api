class ConcernSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :selected
end
