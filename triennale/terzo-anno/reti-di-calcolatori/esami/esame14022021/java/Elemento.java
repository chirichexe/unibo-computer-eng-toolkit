public class Elemento {
    private String id;
    private String cartaId;
    private String marca;
    private String img;

    // Costruttore
    public Elemento() {
        this.id = "L";
        this.cartaId = "L";
        this.marca = "L";
        this.img = "L";
    }

    // Getter e Setter
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCartaId() {
        return cartaId;
    }

    public void setCartaId(String cartaId) {
        this.cartaId = cartaId;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }
}
