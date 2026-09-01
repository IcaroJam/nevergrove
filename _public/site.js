const root = document.querySelector(":root")

const acc = {
	"R": "red",
	"Y": "yellow",
	"T": "teal",
	"P": "purple"
}

const inv = {
	"R": "teal",
	"Y": "blue",
	"T": "mulberry",
	"P": "yellow"
}

let swatches = []

function capitalize(s) {
    return String(s[0]).toUpperCase() + String(s).slice(1)
}

function toCol(c) {
	console.log("Changing to accent " + c)
	root.style.setProperty("--bg0", `var(--bg${c}0)`)
	root.style.setProperty("--bg1", `var(--bg${c}1)`)
	root.style.setProperty("--bg2", `var(--bg${c}2)`)
	root.style.setProperty("--bg3", `var(--bg${c}3)`)
	root.style.setProperty("--bg4", `var(--bg${c}4)`)
	root.style.setProperty("--bg5", `var(--bg${c}5)`)
	root.style.setProperty("--bg6", `var(--bg${c}6)`)
	root.style.setProperty("--fgDim", `var(--fg${c}Dim)`)
	root.style.setProperty("--bgRed", `var(--bg${c}Red)`)
	root.style.setProperty("--bgOrange", `var(--bg${c}Orange)`)
	root.style.setProperty("--bgYellow", `var(--bg${c}Yellow)`)
	root.style.setProperty("--bgGreen", `var(--bg${c}Green)`)
	root.style.setProperty("--bgTeal", `var(--bg${c}Teal)`)
	root.style.setProperty("--bgBlue", `var(--bg${c}Blue)`)
	root.style.setProperty("--bgLavender", `var(--bg${c}Lavender)`)
	root.style.setProperty("--bgPurple", `var(--bg${c}Purple)`)
	root.style.setProperty("--bgPink", `var(--bg${c}Pink)`)
	root.style.setProperty("--bgMulberry", `var(--bg${c}Mulberry)`)
	root.style.setProperty("--gray0", `var(--gray${c}0)`)
	root.style.setProperty("--gray1", `var(--gray${c}1)`)
	root.style.setProperty("--gray2", `var(--gray${c}2)`)

	root.style.setProperty("--accent", `var(--${acc[c]})`)
	root.style.setProperty("--bgAccent", `var(--bg${capitalize(acc[c])})`)
	root.style.setProperty("--invAccent", `var(--${inv[c]})`)
	root.style.setProperty("--vis", `var(--vis${c})`)

	if (document.readyState == "complete") { updateHexes() }
}

function toggleModeKeyboard(ev) {
	if (ev.keyCode === 13) toggleMode(ev)
}

function toggleMode(ev) {
	ev.preventDefault()
	document.body.classList.toggle("light")

	if (document.readyState == "complete") { updateHexes() }
}

function loadSwatches() {
	swatches = document.querySelectorAll(".swatch")
	swatches.forEach(s => {
		const color = s.querySelector("span:first-of-type").innerHTML
		s.firstElementChild.style.setProperty("background-color", `var(--${color})`)
	})
}

function updateHexes() {
	const vars = window.getComputedStyle(document.body)
	swatches.forEach(s => {
		const color = s.querySelector("span:first-of-type").innerHTML
		s.lastElementChild.innerHTML = vars.getPropertyValue(`--${color}`)
		adjustColorFromBrightness(s.firstElementChild)
	})
}

// Taken from https://stackoverflow.com/a/5624139
function hexToRgb(hex) {
	var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
	return result ? {
		r: parseInt(result[1], 16),
		g: parseInt(result[2], 16),
		b: parseInt(result[3], 16)
	} : null
}

function rgbFromString(rgb) {
	const arr = rgb.split(/[(),]/)
	return {
		r: arr[1],
		g: arr[2],
		b: arr[3]
	}
}

// Based on http://alienryderflex.com/hsp.html
function isLightColor(r, g, b) {
	return Math.sqrt(0.299 * r * r + 0.587 * g * g + 0.114 * b * b) > 127.5
}

function adjustColorFromBrightness(el) {
	const colName = el.style.backgroundColor.substring(4, el.style.backgroundColor.length - 1)
	const color = window.getComputedStyle(document.body).getPropertyValue(colName)
	const rgb = color[0] === "#" ? hexToRgb(color) : rgbFromString(color)

	el.style.color = isLightColor(rgb.r, rgb.g, rgb.b) ? "var(--black)" : "var(--white)"
}

function copyToClipboard(el) {
	navigator.clipboard.writeText(el.lastElementChild.innerHTML)
	el.classList.toggle("colorCopied")
	setTimeout(() => el.classList.toggle("colorCopied"), 1500)
}

// window.onload = toCol("P")
document.addEventListener("DOMContentLoaded", ev => {
	loadSwatches()
	updateHexes()
})