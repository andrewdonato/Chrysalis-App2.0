require 'date'

class BasketsController < ApplicationController
  include StocksHelper

  before_action :authenticate_request

  def index
    baskets = @current_user.baskets.includes(:records)
    render json: baskets.to_json(
      root:    false,
      methods: [:performance],
      include: [:records],
    )
  end

  def show

  end

  def destroy
    p '*************'
    p info_params["id"]
    Basket.find(info_params["id"].to_i).destroy
    render json: {messsage: 'delete success'}
  end

  def today
    # fix the date
    basket = []

    @current_user.baskets.find_by(date: 'today').records.each do |record|
      basket << record
    end

    info = {today_basket: basket}
    render json: info
  end

  def create
    p info_params
    basket = @current_user.baskets.create(name: info_params["info"]["name"].to_s.capitalize!, date: Time.now())
    records_id = []
    info_params["info"]["ids"].each do |key, ticker|
      records_id << Record.where(ticker: ticker).last.id
    end
    records_id.each do |id|
      basket.records_baskets.create(record_id: id)
    end
    render json: {message: "success"}
  end

  private
    def info_params
      params.permit!
    end

end
