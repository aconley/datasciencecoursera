# Programming in R Coursera Assignment 2

# This creates a 'wrapped' matrix
# which uses memoization on the matrix inverse
# Arguments
#   x: input matrix of class matrix.
# Returns:
#   A wrapped matrix supporting the following functions:
#     get : gets the actual matrix
#     set : sets the matrix
#     getInv: get the matrix inverse.  Returns NULL if
#              not previously computed
#     setInv: set the inverse; this should not be called
#              by the user, but instead accessed through
#              the cacheSolve function below
makeCacheMatrix <- function(x = matrix()) {
  # Inverse stored in invMat, actual matrix in x
  invMat <- NULL  # Stores the inverse, NULL before computed
  
  set <- function(inmat) {
    x <<- inmat  # Stores inverse matrix
    invMat <<- NULL  # New matrix, so remove any previous inv
  }
  get <- function() x  # Gets matrix
  setInv <- function(inv) invMat <<- inv  # User shouldn't call
  getInv <- function() invMat
  
  list(set=set, get=get, setInv=setInv, getInv=getInv)
}


## Computes the inverse of the matrix specified
##  by x, but uses the memoized inverse if available
## Arguments:
##  x : the input matrix wrapped as in makeCacheMatrix
## ... : optional arguments to the builtin solve function
## Returns:
##  The matrix inverse
cacheSolve <- function(x, ...) {
  inv <- x$getInv()
  if (is.null(inv)) {
    # We have to compute the inverse
    inv <- solve(x$get(), ...)
    x$setInv(inv)  # Store it back
  } else {
    inv <- x$getInv()
  }
  inv
}
