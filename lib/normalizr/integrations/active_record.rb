ActiveSupport.on_load(:active_record) do
  include Normalizr::Concern
end
