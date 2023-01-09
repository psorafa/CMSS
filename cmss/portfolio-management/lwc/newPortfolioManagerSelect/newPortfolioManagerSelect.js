import { LightningElement } from 'lwc'
import search from '@salesforce/apex/NewPortfolioManagerSelectController.search'
import Searching from '@salesforce/label/c.Searching'
import NoResults from '@salesforce/label/c.NoResults'

export default class NewPortfolioManagerSelect extends LightningElement {

    selectedUser = null
    searchTerm = null
    options = null
    timeout = null
    searching = false
    anotherSearchPending = false
    hasFocus = false

    labels = {
        Searching,
        NoResults
    }

    get hasValue() {
        return this.selectedUser
    }
    get showInput() {
        return !this.selectedUser
    }
    get showDropdown() {
        return this.searchTerm && this.searchTerm.length >= 3 && this.hasFocus
    }
    get noResults() {
        return (!this.options || this.options.length == 0) && !this.searching
    }

    handleSearch() {
        if (this.searching) {
            this.anotherSearchPending = true
        } else {
            if (this.searchTerm && this.searchTerm.length >= 3) {
                this.searching = true
                search({
                    term : this.searchTerm
                }).then(result => {
                    this.processSearchResults(result)
                }).catch(error => {
                    // todo error handling
                    console.log('error', JSON.stringify(error))
                })
            } else {
                processSearchResults(null)
            }
            this.anotherSearchPending = false
        }
    }

    processSearchResults(result) {
        this.options = null
        if (result && result.length > 0) {
            this.options = [...result]
        }
        this.searching = false
        if (this.anotherSearchPending) {
            this.handleSearch()
        }
    }

    handleKeyup(event) {
        if (this.searchTerm != event.target.value) {
            this.searchTerm = event.target.value
            if (this.timeout) {
                clearTimeout(this.timeout)
            }
            this.timeout = setTimeout(() => this.handleSearch())
        }
    }

    handleOptionClick(event) {
        this.selectedUser = {
            name: event.currentTarget.dataset.name,
            id: event.currentTarget.dataset.id
        }
        this.searchTerm = null
        this.fireChange(this.selectedUser.id)
    }

    handleClear(event) {
        event.preventDefault()
        event.stopPropagation()
        this.selectedUser = null
        setTimeout(() => {
            this.template.querySelector('[data-id="searchInput"]').focus()
        })
        this.fireChange(null)
    }

    handleFocus(event) {
        this.hasFocus = true
    }

    handleBlur(event) {
        this.hasFocus = false
    }

    handleOptionMouseDown(event) {
        // this is needed so the onClick on option is handled before onBlur of field
        event.preventDefault()
    }

    fireChange(newValue) {
        this.dispatchEvent(new CustomEvent('change', { detail : newValue}))
    }
}