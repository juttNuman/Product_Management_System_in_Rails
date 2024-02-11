class CartsController < ApplicationController
before_action :find_user

def index
@carts=Cart.all
end


def total_bill
    @carts = current_user.carts
    @total_bill = @carts.sum(:bill)
end


def place_order

  @carts = current_user.carts
  @cart = @carts.last
  OrderMailer.order_confirmation_email(current_user,@cart).deliver_now
 redirect_to total_bill_path, notice: 'Please confirm from your email'
end



def confirm_order
 carts=current_user.carts
 carts.destroy_all
  # cart = current_user.carts.last
  # all_carts = current_user.carts

  # if cart && cart.token == params[:token]
  #   redirect_to total_bill_path, notice: 'Order placed successfully!'
  #   all_carts.destroy_all
  # end
  
end




def create
   
 @cart = current_user.carts.build(cart_params)
  @product = Product.find(params[:product_id])

  @cart.bill = @cart.quantity * @product.price

  @cart.token = SecureRandom.urlsafe_base64
    if @cart.save
      redirect_to cart_path(@cart), notice: "Cart was successfully created."
    else
      render 'new'
    end
  end

  


  def show
    @cart = Cart.find(params[:id])
  end

  def new
    @cart=Cart.new
    @cart.product_id=params[:id]
  end


 private
    def cart_params

      params.require(:cart).permit(:quantity,:product_id,:user_id,:token)
    end

    def find_user
      @user ||= User.find_by(id:params[:user_id])
    end
end
