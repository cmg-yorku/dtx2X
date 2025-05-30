package ca.yorku.cmg.istardt.xmlparser.objects;

public class GTOperator extends OperatorDecorator {
    public GTOperator(Formula left, Formula right) {
        this.left = left;
        this.right = right;
    }

    public Formula getLeft() {
    	return(this.left);
    }
    
    public Formula getRight() {
    	return(this.right);
    }
    
    @Override
    public String getFormula() {
        return "(" + left.getFormula() + " > " + right.getFormula() + ")";
    }
}