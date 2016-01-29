class WithdrawsController < ApplicationController
  def index
    @author = current_user.author
    @balance = @author.balance
  end

  def new
    @author = current_user.author
    @balance = @author.balance
    @withdraw = Withdraw.new
  end

  def create
    @author = current_user.author
    if withdraw_params[:amount] < @author.balance
      @withdraw = Withdraw.new(withdraw_params)
      @withdraw.author = @author
      @withdraw.fee = @author.fee
      @withdraw.save
    else
      render 'new'
    end
  end

  private

  def withdraw_params
    params.require(:withdraw).permit(:amount, :account)
  end
end
