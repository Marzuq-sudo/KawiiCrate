document.addEventListener("DOMContentLoaded", () => {

    const productButtons = document.querySelectorAll(".product-bottom button");

    productButtons.forEach(button => {

        button.addEventListener("click", () => {

            if (button.textContent === "♡") {
                button.textContent = "♥";
                button.style.background = "#fff0f5";
            } else {
                button.textContent = "♡";
                button.style.background = "white";
            }

        });

    });

});