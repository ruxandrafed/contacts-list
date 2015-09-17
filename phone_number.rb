class PhoneNumber < ActiveRecord::Base

  belongs_to :contact

  validates :phonetype, presence: true, length: { minimum: 1 }
  validates :number, presence: true, length: { minimum: 1, maximum: 10 }

  def to_s
    "#{phonetype}: #{number}".colorize(:yellow)
  end

end
