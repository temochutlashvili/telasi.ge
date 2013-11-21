# -*- encoding : utf-8 -*-
class Network::Stage
  include Mongoid::Document
  include Mongoid::Timestamps
  field :numb, type: Integer
  field :name, type: String

  def self.auto_numerate
    last_index = 0
    Network::Stage.where(:numb.ne => nil).asc(:numb).each_with_index do |st, index|
      last_index = st.numb = index + 1
      st.save
    end
    Network::Stage.where(numb: nil).each_with_index do |st, index|
      st.numb = last_index + index + 1
      st.save
    end
  end
end
