import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "image", "images" ]
  
  connect() {
    this.mainImgIndex = 0
    console.log('Carousel connected, total items:', this.imagesTargets.length)
    // Initialize with first element
    this.updateImgs()
    
    // Add touch support
    this.setupTouchEvents()
  }

  select(event) {
    const selectedElement = event.target.closest('[data-carousel-target="images"]')
    this.mainImgIndex = [...this.imagesTargets].indexOf(selectedElement)
    console.log('Selected index:', this.mainImgIndex)
    this.updateImgs()
  }

  updateImgs(){
    console.log('Updating to index:', this.mainImgIndex, 'of', this.imagesTargets.length)

    this.imagesTargets.forEach(item => {
      item.classList.remove("active")
    });
    
    const selectedElement = this.imagesTargets[this.mainImgIndex];
    if (!selectedElement) {
      console.error('No element found at index:', this.mainImgIndex)
      return
    }
    
    selectedElement.classList.add("active")
    
    // Update main image
    if (this.imageTarget) {
      this.imageTarget.src = selectedElement.src
      console.log('Updated main image to:', selectedElement.src)
    }
    
    // Update button states
    this.updateButtonStates()
    
    selectedElement.parentNode.scrollTo({ left: selectedElement.offsetLeft - selectedElement.width, behavior: 'smooth' });
  }

  updateButtonStates() {
    const prevButton = this.element.querySelector('.carousel-prev')
    const nextButton = this.element.querySelector('.carousel-next')
    
    // Disable/enable previous button
    if (this.mainImgIndex === 0) {
      prevButton.disabled = true
      prevButton.style.opacity = '0.5'
      prevButton.style.cursor = 'not-allowed'
    } else {
      prevButton.disabled = false
      prevButton.style.opacity = '1'
      prevButton.style.cursor = 'pointer'
    }
    
    // Disable/enable next button
    if (this.mainImgIndex === this.imagesTargets.length - 1) {
      nextButton.disabled = true
      nextButton.style.opacity = '0.5'
      nextButton.style.cursor = 'not-allowed'
    } else {
      nextButton.disabled = false
      nextButton.style.opacity = '1'
      nextButton.style.cursor = 'pointer'
    }
  }

  next() {
    console.log('Next clicked, current index:', this.mainImgIndex)
    if (this.mainImgIndex < this.imagesTargets.length - 1) {
      this.mainImgIndex += 1
      this.updateImgs()
    }
  }

  previous() {
    console.log('Previous clicked, current index:', this.mainImgIndex)
    if (this.mainImgIndex > 0) {
      this.mainImgIndex -= 1
      this.updateImgs()
    }
  }

  setupTouchEvents() {
    const imageElement = this.imageTarget
    if (!imageElement) return
    
    let startX = 0
    let startY = 0
    let isDragging = false
    
    // Touch start
    imageElement.addEventListener('touchstart', (e) => {
      startX = e.touches[0].clientX
      startY = e.touches[0].clientY
      isDragging = true
    }, { passive: true })
    
    // Touch end
    imageElement.addEventListener('touchend', (e) => {
      if (!isDragging) return
      
      const endX = e.changedTouches[0].clientX
      const endY = e.changedTouches[0].clientY
      const diffX = startX - endX
      const diffY = startY - endY
      
      // Check if it's a horizontal swipe (more horizontal than vertical)
      if (Math.abs(diffX) > Math.abs(diffY) && Math.abs(diffX) > 50) {
        if (diffX > 0) {
          // Swipe left (next image)
          this.next()
        } else {
          // Swipe right (previous image)
          this.previous()
        }
      }
      
      isDragging = false
    }, { passive: true })
    
    // Prevent default touch behavior on the image
    imageElement.addEventListener('touchmove', (e) => {
      if (isDragging) {
        e.preventDefault()
      }
    })
  }
}
