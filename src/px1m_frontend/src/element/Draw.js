import { html } from 'lit-html';
import { ref, createRef } from 'lit-html/directives/ref.js';
import { colors } from '../../../util/js/color';

console.log('colors', colors.length);
export default class Draw {
  static PATH = '/draw';
  
  constructor(backend) {
    this.canvasb = backend;
    this.wallet = backend.wallet;
    this.notif = backend.wallet.notif;
    
    this.selectedColor = 1; // current color index
    this.isDrawing = false;
    this.pixelSize = 10; // display size of each pixel
    this.canvasRef = createRef();
    this.ctx = null;
    
    this.button = html`
      <button 
        class="inline-flex items-center px-2 py-1 text-xs rounded-md font-medium bg-slate-800 hover:bg-slate-700 text-slate-100 ring-1 ring-slate-700"
        @click=${(e) => {
          e.preventDefault();
          if (window.location.pathname.startsWith(Draw.PATH)) return;
          history.pushState({}, '', Draw.PATH);
          window.dispatchEvent(new PopStateEvent('popstate'));
        }}>Draw</button>
    `;
  }

  initCanvas() {
    const canvas = this.canvasRef.value;
    if (!canvas || this.ctx) return;
    
    this.ctx = canvas.getContext('2d');
    this.redraw();
  }

  getPixelCoords(e) {
    const canvas = this.canvasRef.value;
    const rect = canvas.getBoundingClientRect();
    const x = Math.floor((e.clientX - rect.left) / this.pixelSize);
    const y = Math.floor((e.clientY - rect.top) / this.pixelSize);
    return { x, y };
  }

  setPixel(x, y) {
    const { width, height, buffer } = this.canvasb;
    if (x < 0 || x >= width || y < 0 || y >= height) return;
    
    const idx = y * width + x;
    buffer[idx] = this.selectedColor;
    
    // Draw to canvas
    this.ctx.fillStyle = colors[this.selectedColor].hex || '#000';
    this.ctx.fillRect(x * this.pixelSize, y * this.pixelSize, this.pixelSize, this.pixelSize);
  }

  handleMouseDown(e) {
    this.initCanvas();
    this.isDrawing = true;
    const { x, y } = this.getPixelCoords(e);
    this.setPixel(x, y);
  }

  handleMouseMove(e) {
    if (!this.isDrawing) return;
    const { x, y } = this.getPixelCoords(e);
    this.setPixel(x, y);
  }

  handleMouseUp() {
    this.isDrawing = false;
  }

  redraw() {
    if (!this.ctx) return;
    const { width, height, buffer } = this.canvasb;
    
    // Fill background
    this.ctx.fillStyle = colors[0].hex || '#000';
    this.ctx.fillRect(0, 0, width * this.pixelSize, height * this.pixelSize);
    
    // Draw all pixels
    for (let y = 0; y < height; y++) {
      for (let x = 0; x < width; x++) {
        const colorIdx = buffer[y * width + x];
        if (colorIdx !== 0) {
          this.ctx.fillStyle = colors[colorIdx].hex || '#000';
          this.ctx.fillRect(x * this.pixelSize, y * this.pixelSize, this.pixelSize, this.pixelSize);
        }
      }
    }
  }

  selectColor(idx) {
    this.selectedColor = idx;
    this.render();
  }

  render() {
    if (this.canvasb.width == null) {
      return html`<div class="p-4 text-slate-400">Loading metadata…</div>`;
    }
    
    const { width, height } = this.canvasb;
    const displayWidth = width * this.pixelSize;
    const displayHeight = height * this.pixelSize;

    // Schedule canvas init after render
    setTimeout(() => this.initCanvas(), 0);

    return html`
      <div class="fixed inset-0 pt-12 flex bg-slate-950">
        <!-- Canvas area (left) -->
        <div class="flex-1 overflow-auto flex items-center justify-center p-4">
          <canvas
            ${ref(this.canvasRef)}
            width=${displayWidth}
            height=${displayHeight}
            class="border border-slate-700 cursor-crosshair bg-black shadow-lg"
            @mousedown=${(e) => this.handleMouseDown(e)}
            @mousemove=${(e) => this.handleMouseMove(e)}
            @mouseup=${() => this.handleMouseUp()}
            @mouseleave=${() => this.handleMouseUp()}
          ></canvas>
        </div>
        
        <!-- Color picker (right) -->
        <div class="w-8 bg-slate-900 border-l border-slate-700 overflow-y-auto flex flex-col">
          ${colors.map((color, i) => html`
            <button
              title="${color.name}"
              class="w-full h-6 shrink-0 transition-all
                ${this.selectedColor === i 
                  ? 'ring-2 ring-inset ring-white scale-110 z-10' 
                  : 'hover:scale-105'}"
              style="background-color: ${color.hex}"
              @click=${() => this.selectColor(i)}
              title="Color ${i}"
            ></button>
          `)}
        </div>
      </div>
    `;
  }
}