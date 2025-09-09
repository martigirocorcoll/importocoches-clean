const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  
  try {
    await page.goto('http://localhost:3000');
    await page.waitForLoadState('networkidle');
    
    // Obtener el CSS cargado
    const stylesheets = await page.evaluate(() => {
      const links = document.querySelectorAll('link[rel="stylesheet"]');
      return Array.from(links).map(link => link.href);
    });
    
    console.log('📄 CSS files loaded:');
    stylesheets.forEach(css => console.log('  -', css));
    
    // Buscar elementos con colores rojos
    const redElements = await page.evaluate(() => {
      const elements = document.querySelectorAll('*');
      const redOnes = [];
      
      elements.forEach(el => {
        const computed = getComputedStyle(el);
        const bgColor = computed.backgroundColor;
        const color = computed.color;
        const borderColor = computed.borderColor;
        
        if (bgColor.includes('253, 16, 21') || bgColor.includes('#FD1015') ||
            color.includes('253, 16, 21') || color.includes('#FD1015') ||
            borderColor.includes('253, 16, 21') || borderColor.includes('#FD1015')) {
          redOnes.push({
            tag: el.tagName,
            class: el.className,
            id: el.id,
            bgColor: bgColor,
            color: color,
            borderColor: borderColor
          });
        }
      });
      
      return redOnes;
    });
    
    // Buscar elementos con azul eléctrico
    const blueElements = await page.evaluate(() => {
      const elements = document.querySelectorAll('*');
      const blueOnes = [];
      
      elements.forEach(el => {
        const computed = getComputedStyle(el);
        const bgColor = computed.backgroundColor;
        const color = computed.color;
        const borderColor = computed.borderColor;
        
        if (bgColor.includes('0, 102, 255') || bgColor.includes('#0066FF') ||
            color.includes('0, 102, 255') || color.includes('#0066FF') ||
            borderColor.includes('0, 102, 255') || borderColor.includes('#0066FF')) {
          blueOnes.push({
            tag: el.tagName,
            class: el.className,
            id: el.id,
            bgColor: bgColor,
            color: color,
            borderColor: borderColor
          });
        }
      });
      
      return blueOnes.slice(0, 10); // Solo los primeros 10
    });
    
    console.log('🔴 Red elements found:', redElements.length);
    if (redElements.length > 0) {
      console.log('Red elements:');
      redElements.slice(0, 5).forEach((el, i) => {
        console.log(`  ${i+1}. ${el.tag}.${el.class} - bg:${el.bgColor} color:${el.color}`);
      });
    }
    
    console.log('🔵 Blue elements found:', blueElements.length);
    if (blueElements.length > 0) {
      console.log('Blue elements (first 5):');
      blueElements.slice(0, 5).forEach((el, i) => {
        console.log(`  ${i+1}. ${el.tag}.${el.class} - bg:${el.bgColor} color:${el.color}`);
      });
    }
    
    // Tomar screenshot
    await page.screenshot({ path: 'current_page.png', fullPage: true });
    console.log('📸 Screenshot saved as current_page.png');
    
  } catch (error) {
    console.error('❌ Error:', error.message);
  }
  
  await browser.close();
})();