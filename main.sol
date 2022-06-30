//SPDX-License-Identifier:sample
pragma solidity ^0.8.0;

contract Hungrryyyy {
    struct Item {
        uint quantity;
        uint price;
    }
    address public restaurent;
    uint public CashBalance;
    string[] availableItems;
    mapping(string=>Item) public FoodItems;

    constructor(string[] memory _item, uint[] memory _quantity, uint[] memory _price, uint cash) {
        require(_item.length==_quantity.length && _item.length==_price.length,"Invalid Inventory");
        for(uint i=0; i<_item.length; i++) {
            FoodItems[_item[i]]=Item(_quantity[i],_price[i]);
            availableItems.push(_item[i]);
        }
        CashBalance=cash;
        restaurent=msg.sender;
    }

    function addItem(string memory _item, uint _quantity, uint _price) public {
        require(msg.sender==restaurent,"Only owner can add items");
        if(FoodItems[_item].price!=0) {
            FoodItems[_item].quantity+=_quantity;
            FoodItems[_item].price=_price;
        } else {
            FoodItems[_item]=Item(_quantity,_price);
            availableItems.push(_item);
        }
    }

    function showAvailableItems() public view returns(string[] memory){
        return availableItems;
    }

    function order (string[] memory items, uint[] memory quantity) public payable {
        require(items.length==quantity.length,"Invalid order");
        uint billedAmount=0;
        for(uint i=0; i<items.length; i++) {
            require(FoodItems[items[i]].quantity>=quantity[i],"Not enough quantity available");
            billedAmount += (FoodItems[items[i]].price * quantity[i]);
            FoodItems[items[i]].quantity-=quantity[i];
        }
        pay(billedAmount);
    }

    function pay(uint billedAmount) private {
        require(msg.value>=billedAmount,"Insufficient balance");
        CashBalance+=billedAmount;
    }
}