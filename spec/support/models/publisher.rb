class Publisher < ActiveRecord::Base
  attr_accessor :custom_writer

  normalize :name, with: :blank
  normalize :phone_number, with: :phone

  def name=(_)
    self.custom_writer = true
    super
  end
end
