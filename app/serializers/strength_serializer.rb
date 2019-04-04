class StrengthSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :selected
end
